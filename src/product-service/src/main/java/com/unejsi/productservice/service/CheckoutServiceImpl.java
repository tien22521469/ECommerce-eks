package com.unejsi.productservice.service;

import com.unejsi.productservice.dao.CustomerRepository;
import com.unejsi.productservice.dto.Purchase;
import com.unejsi.productservice.dto.PurchaseResponse;
import com.unejsi.productservice.entity.Customer;
import com.unejsi.productservice.entity.Order;
import com.unejsi.productservice.entity.OrderItem;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Set;
import java.util.UUID;

@Service
public class CheckoutServiceImpl implements CheckoutService{

    private final CustomerRepository customerRepository;
    private final RestTemplate restTemplate;
    private final String userValidationUrl;

    @Autowired
    public CheckoutServiceImpl(CustomerRepository customerRepository,
                               RestTemplate restTemplate,
                               @Value("${user.service.validate-url}") String userValidationUrl){
        this.customerRepository = customerRepository;
        this.restTemplate = restTemplate;
        this.userValidationUrl = userValidationUrl;
    }
    @Override
    @Transactional
    public PurchaseResponse placeOrder(Purchase purchase) {
        //retrieve the order info from dto
        Order order = purchase.getOrder();

        //generate tracking number
        String orderTrackingNumber = generateOrderTrackingNumber();
        order.setOrderTrackingNumber(orderTrackingNumber);

        //populate order with orderItems
        Set<OrderItem> orderItems = purchase.getOrderItems();
        for(OrderItem item: orderItems){
            order.add(item);
        }

        //populate order with billingAddress and shippingAddress
        order.setBillingAddress(purchase.getBillingAddress());
        order.setShippingAddress(purchase.getShippingAddress());

        //populate customer with order
        Customer customer = purchase.getCustomer();

        //check if this is an existing customer based on email add
        String theEmail = customer.getEmail();

        if (!validateUserExists(theEmail)) {
            throw new RuntimeException("Cannot place order. No user registered with email " + theEmail);
        }

        Customer customerFromDb = customerRepository.findByEmail(theEmail);

        if(customerFromDb != null){
            customer = customerFromDb;
        }

        customer.add(order);

        //save to the database
        customerRepository.save(customer);

        //return a response

        return new PurchaseResponse(orderTrackingNumber);
    }

    //we want a unique id that is hard to guess and random
    private String generateOrderTrackingNumber() {

        //generate a random UUID number (UUID version-4)
        return UUID.randomUUID().toString();
    }

    private boolean validateUserExists(String email) {
        String uri = UriComponentsBuilder.fromHttpUrl(userValidationUrl)
                .queryParam("email", email)
                .toUriString();

        Boolean response = restTemplate.getForObject(uri, Boolean.class);
        return Boolean.TRUE.equals(response);
    }
}
