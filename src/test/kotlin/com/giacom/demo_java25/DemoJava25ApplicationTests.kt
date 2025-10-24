package com.giacom.demo_java25

import org.junit.jupiter.api.Test
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Import

@Import(TestcontainersConfiguration::class)
@SpringBootTest
class DemoJava25ApplicationTests {

	@Test
	fun contextLoads() {
	}

}
