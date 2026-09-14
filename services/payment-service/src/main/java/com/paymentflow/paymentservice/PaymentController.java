package com.paymentflow.paymentservice;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import java.time.Instant;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @Value("${APP_ENV:unset}")
    private String appEnv;

    @PostMapping("/process")
    public Map<String, Object> processPayment(@RequestBody Map<String, Object> request) {
        String orderId = (String) request.get("orderId");
        Double amount = ((Number) request.get("amount")).doubleValue();
        
        // In reality, this inserts an immutable ledger entry
        return Map.of(
            "transactionId", UUID.randomUUID().toString(),
            "orderId", orderId,
            "amount", amount,
            "status", "COMPLETED",
            "timestamp", Instant.now(),
            "environment", appEnv,
            "pod", System.getenv().getOrDefault("HOSTNAME", "unknown")
        );
    }

    @GetMapping("/{transactionId}")
    public Map<String, Object> getTransaction(@PathVariable String transactionId) {
        return Map.of(
            "transactionId", transactionId,
            "status", "COMPLETED",
            "environment", appEnv
        );
    }
}
