package com.unejsi.productservice.dto;

import com.unejsi.productservice.entity.Address;
import com.unejsi.productservice.entity.Customer;
import com.unejsi.productservice.entity.Order;
import com.unejsi.productservice.entity.OrderItem;
import lombok.Data;

import java.util.Set;

@Data
public class Purchase {

    private Customer customer;

    private Address shippingAddress;

    private Address billingAddress;

    private Order order;

    private Set<OrderItem> orderItems;
}
