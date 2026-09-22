package pl.skarbkibica.web;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.InvalidMediaTypeException;
import org.springframework.http.MediaType;
import org.springframework.web.servlet.resource.PathResourceResolver;
import org.springframework.web.servlet.resource.ResourceResolverChain;
import org.springframework.web.util.UriUtils;

class SpaResourceResolver extends PathResourceResolver {

	private static final Set<String> RESERVED_SEGMENTS = Set.of("api", "error", "actuator", "h2-console");

	@Override
	protected Resource resolveResourceInternal(HttpServletRequest request, String resourcePath,
			List<? extends Resource> locations, ResourceResolverChain chain) {
		String decodedPath;
		try {
			decodedPath = UriUtils.decode(resourcePath, StandardCharsets.UTF_8);
		} catch (IllegalArgumentException exception) {
			return null;
		}
		List<String> segments = Arrays.stream(decodedPath.split("/"))
				.filter(segment -> !segment.isEmpty())
				.toList();
		if ((!segments.isEmpty() && RESERVED_SEGMENTS.contains(segments.getFirst()))
				|| segments.stream().anyMatch(segment -> segment.startsWith("."))) {
			return null;
		}

		Resource resource = super.resolveResourceInternal(request, resourcePath, locations, chain);
		if (resource != null) {
			return resource;
		}
		if (request == null || !(request.getMethod().equals("GET") || request.getMethod().equals("HEAD"))
				|| decodedPath.contains(".") || !explicitlyAcceptsHtml(request)) {
			return null;
		}
		return super.resolveResourceInternal(request, "index.html", locations, chain);
	}

	private boolean explicitlyAcceptsHtml(HttpServletRequest request) {
		try {
			return MediaType.parseMediaTypes(Collections.list(request.getHeaders(HttpHeaders.ACCEPT))).stream()
					.anyMatch(type -> type.getType().equals("text") && type.getSubtype().equals("html")
							&& type.getQualityValue() > 0);
		} catch (InvalidMediaTypeException exception) {
			return false;
		}
	}
}
