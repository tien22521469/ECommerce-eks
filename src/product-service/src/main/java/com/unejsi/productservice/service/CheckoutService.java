package com.unejsi.productservice.service;

import com.unejsi.productservice.dto.Purchase;
import com.unejsi.productservice.dto.PurchaseResponse;

public interface CheckoutService {


    PurchaseResponse  placeOrder(Purchase purchase);
}
