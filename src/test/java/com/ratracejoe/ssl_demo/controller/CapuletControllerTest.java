package com.ratracejoe.ssl_demo.controller;

import com.ratracejoe.ssl_demo.mock.CapuletMockExtension;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.RegisterExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpStatus;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * This test demonstrates use of Wiremock to create the underlying server.
 * Wiremock is good for simulating other microserices within your closed enterprise,
 * or just running something cheaper and smaller than a full blown container.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class CapuletControllerTest {
    @Autowired
    private TestRestTemplate testRestTemplate;

    @RegisterExtension
    protected final CapuletMockExtension capuletMockExtension =
            new CapuletMockExtension();

    @Test
    void getJuliet() {
        var response = testRestTemplate.getForEntity("/capulet", String.class);

        assertThat(response.getStatusCode().value()).isEqualTo(HttpStatus.OK.value());
        assertThat(response.getBody()).contains("<h1>Hello from Capulets</h1>");
    }
}
