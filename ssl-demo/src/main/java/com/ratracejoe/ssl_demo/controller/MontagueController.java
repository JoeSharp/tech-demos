package com.ratracejoe.ssl_demo.controller;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;

@RestController
@RequestMapping("/montague")
public class MontagueController {
    private RestClient restClient;

    @Value("${external.montague-url}")
    private String montagueUrl;

    public MontagueController(@Qualifier("montague") RestClient restClient) {
        this.restClient = restClient;
    }

    @GetMapping(produces = MediaType.TEXT_HTML_VALUE)
    String getHomePage() {
        return restClient.get().uri(montagueUrl).retrieve().body(String.class);
    }
}
