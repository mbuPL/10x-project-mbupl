package pl.skarbkibica;

import java.nio.file.Path;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.jdbc.core.JdbcTemplate;

import static org.assertj.core.api.Assertions.assertThat;

class H2PersistenceTests {

	@Test
	void dataSurvivesApplicationRestart(@TempDir Path directory) {
		Path database = directory.resolve("restart-check");

		try (var application = startApplication(database)) {
			var jdbc = application.getBean(JdbcTemplate.class);
			jdbc.execute("CREATE TABLE persistence_check (id INTEGER PRIMARY KEY, message VARCHAR(100))");
			jdbc.update("INSERT INTO persistence_check (id, message) VALUES (?, ?)", 1, "saved before restart");
		}

		assertThat(directory.resolve("restart-check.mv.db")).exists();

		try (var application = startApplication(database)) {
			var jdbc = application.getBean(JdbcTemplate.class);
			assertThat(jdbc.queryForObject("SELECT message FROM persistence_check WHERE id = ?", String.class, 1))
					.isEqualTo("saved before restart");
		}
	}

	private ConfigurableApplicationContext startApplication(Path database) {
		return new SpringApplicationBuilder(SkarbKibicaApplication.class)
				.web(WebApplicationType.NONE)
				.run("--DB_PATH=" + database);
	}
}
