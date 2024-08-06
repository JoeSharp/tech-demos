package com.ratracejoe.ssl_demo.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.BindMode;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.util.function.Supplier;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * This test demonstrates use of Test Containers to run external dependencies.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
class MontagueControllerTest {
    private static final Integer NGINX_PORT = 443;

    @Autowired
    private TestRestTemplate testRestTemplate;

    @Container
    private static final GenericContainer montague = new GenericContainer<>("nginx")
            .withExposedPorts(NGINX_PORT)
            .withClasspathResourceMapping("nginx/romeo-montague.html", "/usr/share/nginx/html/index.html", BindMode.READ_ONLY)
            .withClasspathResourceMapping("nginx/romeo-montague.conf", "/etc/nginx/conf.d/default.conf", BindMode.READ_ONLY)
            .withClasspathResourceMapping("tls/montague", "/etc/ssl/certs/nginx", BindMode.READ_ONLY);

    @DynamicPropertySource
    public static void dynamicProps(DynamicPropertyRegistry registry) {
        // Override the distinct keycloak realm configs with their respective testcontainers
        Supplier<Object> getMontagueUrl = () -> {
            var port = montague.getMappedPort(NGINX_PORT);
            return  String.format("https://localhost:%d", port);
        };

        registry.add(
                "external.montague-url", getMontagueUrl);
    }

    @Test
    void getRomeo() {
        var response = testRestTemplate.getForEntity("/montague", String.class);

        assertThat(response.getStatusCode().value()).isEqualTo(HttpStatus.OK.value());
        assertThat(response.getBody()).contains("<h1>Welcome to the Home Page of the Montagues</h1>");
    }

}
