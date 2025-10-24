package com.giacom.demo_java25

import org.springframework.boot.fromApplication
import org.springframework.boot.with


fun main(args: Array<String>) {
	fromApplication<DemoJava25Application>().with(TestcontainersConfiguration::class).run(*args)
}
