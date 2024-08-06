package com.ratracejoe.ssl_demo.mock;

import com.github.tomakehurst.wiremock.WireMockServer;
import org.junit.jupiter.api.extension.AfterEachCallback;
import org.junit.jupiter.api.extension.BeforeEachCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.springframework.http.HttpStatus;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static com.github.tomakehurst.wiremock.core.WireMockConfiguration.options;

public class CapuletMockExtension implements BeforeEachCallback, AfterEachCallback {
    public static final Integer CAPULET_MOCK_PORT = 39443;
    private static final WireMockServer capuletMock =
            new WireMockServer(
                    options()
                            .httpDisabled(true)
                            .httpsPort(CAPULET_MOCK_PORT)
                            .needClientAuth(true)
                            // Needs path relative to project root...for some reason
                            .trustStorePath("src/test/resources/tls/capulet/capulet.truststore.jks")
                            .trustStorePassword("changeit")
                            // Happy with path relative to resource root, but giving project root for consistency
                            .keystorePath("src/test/resources/tls/capulet/juliet/juliet.keystore.jks")
                            .keystorePassword("changeit")
                            .keyManagerPassword("changeit")
                            );

    @Override
    public void beforeEach(ExtensionContext context) throws Exception {
        capuletMock.resetAll();
        capuletMock.start();
        capuletMock.stubFor(
                get(urlEqualTo("/"))
                        .willReturn(
                                aResponse()
                                        .withBody("<h1>Hello from Capulets</h1>")
                                        .withStatus(HttpStatus.OK.value())));
    }

    @Override
    public void afterEach(ExtensionContext context) throws Exception {
        capuletMock.stop();
    }
}
