package com.ratracejoe.ssl_demo.config;

import org.springframework.boot.autoconfigure.web.client.RestClientSsl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
public class RestClientConfig {

    @Bean(name = "montague")
    public RestClient montagueRestClient(RestClientSsl ssl) {
        return RestClient.builder()
                .apply(ssl.fromBundle("montague"))
                .build();
    }

    @Bean(name = "capulet")
    public RestClient capuletRestClient(RestClientSsl ssl) {
        return RestClient.builder()
                .apply(ssl.fromBundle("capulet"))
                .build();
    }
}
