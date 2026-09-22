package pl.skarbkibica;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
		"spring.datasource.url=jdbc:h2:mem:spa-routing-tests;DB_CLOSE_DELAY=-1",
		"spring.web.resources.static-locations=classpath:/spa-test/"
})
class SpaRoutingTests {

	private static final String INDEX_MARKER = "isolated-spa-test-index";
	private final HttpClient client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(5)).build();

	@LocalServerPort
	private int port;

	@Test
	void servesIndexAtRoot() throws Exception {
		var response = request("GET", "/", "text/html");

		assertThat(response.statusCode()).isEqualTo(200);
		assertThat(response.body()).contains(INDEX_MARKER);
		assertThat(response.headers().firstValue("Content-Type"))
				.hasValueSatisfying(value -> assertThat(value).contains("text/html"));
		assertThat(response.headers().allValues("Vary")).contains("Accept");
	}

	@ParameterizedTest
	@ValueSource(strings = { "/app-test.js", "/app-test.css", "/robots" })
	void servesExistingAssetsBeforeHtmlFallback(String path) throws Exception {
		var response = request("GET", path, "text/html");

		assertThat(response.statusCode()).isEqualTo(200);
		assertThat(response.body()).contains("isolated-static-asset").doesNotContain(INDEX_MARKER);
	}

	@ParameterizedTest
	@ValueSource(strings = { "/teams", "/teams/123/schedule", "/teams/123/", "/teams?round=2" })
	void servesIndexForHtmlClientNavigation(String path) throws Exception {
		var response = request("GET", path, "text/html,application/xhtml+xml;q=0.9,*/*;q=0.8");

		assertThat(response.statusCode()).isEqualTo(200);
		assertThat(response.body()).contains(INDEX_MARKER);
	}

	@Test
	void supportsHeadWithoutSendingIndexBody() throws Exception {
		var response = request("HEAD", "/teams/123", "text/html");

		assertThat(response.statusCode()).isEqualTo(200);
		assertThat(response.body()).isEmpty();
	}

	@ParameterizedTest
	@ValueSource(strings = {
			"/api", "/api/missing", "/error/missing", "/actuator", "/actuator/env",
			"/h2-console", "/h2-console/login", "/.env", "/.git/config", "/teams/.private/details",
			"/%2egit/config", "/missing.js", "/missing.css", "/assets/missing.png"
	})
	void returnsNotFoundForReservedHiddenOrMissingAssetPaths(String path) throws Exception {
		var response = request("GET", path, "text/html");

		assertThat(response.statusCode()).isEqualTo(404);
		assertThat(response.body()).doesNotContain(INDEX_MARKER);
	}

	@Test
	void preservesErrorHandler() throws Exception {
		var response = request("GET", "/error", "text/html");

		assertThat(response.statusCode()).isNotEqualTo(200);
		assertThat(response.body()).doesNotContain(INDEX_MARKER);
	}

	@ParameterizedTest
	@ValueSource(strings = { "application/json", "*/*", "text/*", "text/html;q=0,*/*;q=1", "invalid-accept" })
	void doesNotUseHtmlFallbackForNonHtmlRequests(String accept) throws Exception {
		var response = request("GET", "/teams/123", accept);

		assertThat(response.statusCode()).isBetween(400, 499);
		assertThat(response.body()).doesNotContain(INDEX_MARKER);
	}

	@Test
	void doesNotUseHtmlFallbackWithoutAcceptHeader() throws Exception {
		var response = request("GET", "/teams/123", null);

		assertThat(response.statusCode()).isEqualTo(404);
		assertThat(response.body()).doesNotContain(INDEX_MARKER);
	}

	@Test
	void doesNotCacheHtmlFallbackForJsonRequestsToSamePath() throws Exception {
		var htmlResponse = request("GET", "/cache-check", "text/html");
		assertThat(htmlResponse.statusCode()).isEqualTo(200);
		assertThat(htmlResponse.headers().allValues("Vary")).contains("Accept");

		var response = request("GET", "/cache-check", "application/json");

		assertThat(response.statusCode()).isEqualTo(404);
		assertThat(response.body()).doesNotContain(INDEX_MARKER);
		assertThat(response.headers().allValues("Vary")).contains("Accept");
	}

	@ParameterizedTest
	@ValueSource(strings = { "POST", "PUT", "PATCH", "DELETE" })
	void doesNotUseHtmlFallbackForMutatingRequests(String method) throws Exception {
		var response = request(method, "/teams/123", "text/html");

		assertThat(response.statusCode()).isBetween(400, 499);
		assertThat(response.body()).doesNotContain(INDEX_MARKER);
	}

	@Test
	void preservesDatabaseHealthEndpointWithoutExposingDetails() throws Exception {
		var response = request("GET", "/api/health", "application/json");

		assertThat(response.statusCode()).isEqualTo(200);
		assertThat(response.body()).contains("\"status\":\"UP\"").doesNotContain("components", "details");
	}

	private HttpResponse<String> request(String method, String path, String accept) throws Exception {
		var builder = HttpRequest.newBuilder(URI.create("http://127.0.0.1:" + port + path))
				.timeout(Duration.ofSeconds(10))
				.method(method, HttpRequest.BodyPublishers.noBody());
		if (accept != null) {
			builder.header("Accept", accept);
		}
		return client.send(builder.build(), HttpResponse.BodyHandlers.ofString());
	}
}
