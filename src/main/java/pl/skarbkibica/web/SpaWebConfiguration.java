package pl.skarbkibica.web;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.ResourceHttpRequestHandler;

@Configuration(proxyBeanMethods = false)
class SpaWebConfiguration implements WebMvcConfigurer {

	private final String[] resourceLocations;

	SpaWebConfiguration(@Value("${spring.web.resources.static-locations:classpath:/static/}") String[] resourceLocations) {
		this.resourceLocations = resourceLocations;
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/**")
				.addResourceLocations(resourceLocations)
				// The fallback depends on Accept; do not cache resolved resources by path alone.
				.resourceChain(false)
				.addResolver(new SpaResourceResolver());
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(new HandlerInterceptor() {
			@Override
			public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
				if (handler instanceof ResourceHttpRequestHandler) {
					// Both the HTML fallback and its corresponding 404 vary by Accept.
					response.addHeader(HttpHeaders.VARY, HttpHeaders.ACCEPT);
				}
				return true;
			}
		});
	}
}
