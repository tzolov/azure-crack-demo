package com.example.azure.azurecracdemo;

import java.util.Optional;
import java.util.function.Function;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class AzureCracDemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(AzureCracDemoApplication.class, args);
	}

	/**
	 * Plain Spring bean (not Spring Cloud Functions!)
	 */
	@Autowired
	private Function<String, String> uppercase;


	@FunctionName("bean")
	public String plainBean(
			@HttpTrigger(name = "req", methods = { HttpMethod.GET,
					HttpMethod.POST }, authLevel = AuthorizationLevel.ANONYMOUS) HttpRequestMessage<Optional<String>> request,
			ExecutionContext context) {

		return this.uppercase.apply(request.getBody().get());
	}

	@Bean
	public Function<String, String> uppercase() {
		return payload -> payload.toUpperCase();
	}

}
