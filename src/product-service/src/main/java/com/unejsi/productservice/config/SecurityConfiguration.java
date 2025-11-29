package com.unejsi.productservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.accept.ContentNegotiationStrategy;
import org.springframework.web.accept.HeaderContentNegotiationStrategy;

@Configuration
public class SecurityConfiguration {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        
        http.authorizeHttpRequests(configurer ->
                configurer
                        // Cho phép xem sản phẩm, danh mục mà không cần đăng nhập
                        .requestMatchers("/api/products/**", "/api/product-category/**").permitAll()
                        // Các API khác (ví dụ mua hàng) thì cần đăng nhập (nếu có)
                        .anyRequest().authenticated()
        );

        // Hỗ trợ CORS (Cho phép Frontend gọi vào)
        http.cors(Customizer.withDefaults());

        // Tắt CSRF vì chúng ta dùng REST API stateless
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }
}
