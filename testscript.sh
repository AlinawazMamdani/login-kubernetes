#!/bin/bash

counter=100
counter2=0
my_array=(mongo mongo-service secret-service aes-encyption-service session-token-service account-service dashboard-service email-service authentication-service role-service group-service dashboard-client authentication-client gateway) 

until [ $counter -gt 114 ]
do
  echo ${my_array[$counter]}
  name=${my_array[$counter2]}
  sed "s/mongo-service/$name/g" mongo-service-service.yaml > ${counter}${name}-service.yaml
  ((counter++))
  ((counter2++))
done

echo ALL done

