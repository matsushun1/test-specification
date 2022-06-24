package com.testspec.demo.infrastructure.repositoryImpl

import com.Tables.M_TEST_FRAME
import com.testspec.demo.domain.model.testcase.read.ReadTestCase
import com.testspec.demo.domain.repository.TestCaseRepository
import org.jooq.DSLContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component

@Component
class TestCaseRepositoryImpl @Autowired constructor(
    val dsl: DSLContext
): TestCaseRepository {

    override fun findAll(): List<ReadTestCase> {
        val result = dsl.select()
            .from(M_TEST_FRAME)
            .orderBy(M_TEST_FRAME.CREATED_AT)
        return result.map {
            ReadTestCase.create(
                testCaseId = it.get(M_TEST_FRAME.TEST_FRAME_ID),
                target = it.get(M_TEST_FRAME.TARGET),
                expected = it.get(M_TEST_FRAME.EXPECTED),
                testSupplement = it.get(M_TEST_FRAME.DESCRIPTION)
            )
        }
    }

}
