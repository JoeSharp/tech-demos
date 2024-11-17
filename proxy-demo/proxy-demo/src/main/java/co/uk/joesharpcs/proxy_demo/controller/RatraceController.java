package co.uk.joesharpcs.proxy_demo.controller;

import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.HttpHost;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

@RestController
public class RatraceController {

    private final RestClient restClient;

    private static final String RATRACEJOE_URL =
            "http://localhost:8080/";
    private static final String EXTERNAL_DEMO_URL =
            "https://www.bbc.co.uk/news";
    private static final String PROXY_HOST = "localhost";
    private static final int PROXY_PORT = 3128;

    public RatraceController() {
        HttpHost proxy = new HttpHost(PROXY_HOST, PROXY_PORT);
        CloseableHttpClient httpClient = HttpClients.custom()
                .setProxy(proxy)
                .build();

        HttpComponentsClientHttpRequestFactory requestFactory =
                new HttpComponentsClientHttpRequestFactory(httpClient);

        this.restClient = RestClient.builder()
                .requestFactory(requestFactory)
                .build();
    }

    @GetMapping
    public String sayHello() {
        return "Hello";
    }

    @GetMapping("/ratracejoe")
    public String getRatraceJoe() {
        return restClient.get().uri(RATRACEJOE_URL)
                .retrieve().body(String.class);
    }

    @GetMapping("/external")
    public String getExternal() {
        return restClient.get().uri(EXTERNAL_DEMO_URL)
                .retrieve().body(String.class);
    }
}
