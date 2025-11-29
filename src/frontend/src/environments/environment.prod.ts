export const environment = {
  production: true,

  // Thay localhost:8082 bằng URL của Product Service LoadBalancer (Cổng 80)
  apiBaseUrl: 'http://a245f9f90c03746d79aec8ce9e63f600-244486027.ap-southeast-1.elb.amazonaws.com/api',
  
  checkoutUrl: 'http://a245f9f90c03746d79aec8ce9e63f600-244486027.ap-southeast-1.elb.amazonaws.com/api/checkout',

  // Thay localhost:8081 bằng URL của User Service LoadBalancer (Cổng 80)
  userServiceUrl: 'http://ac41dc0af274644bc814b33d3a54006f-2094462698.ap-southeast-1.elb.amazonaws.com/api'
};
