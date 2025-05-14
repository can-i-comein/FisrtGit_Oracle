-- SUBQUERY : 하나의 SQL문 안에 포함된 또 다른 SQL문
-- 메인 쿼리(기존 쿼리)를 위해 보조 역할을 하는 쿼리문

-- 노옹철 사원과 같은 소속의 직원 명단 조회
-- 1) 노옹철 사원의 부서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

-- 2) 부서코드가 D9인 직원 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 1) + 2)
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');
                    
-- 전 직원의 평균 급여보다 많이 받는 직원의 사번, 이름, 직급코드, 급여조회
-- 1) 전 직원의 평균 급여
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) 보다 많이 받는 직원의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047662.608;

-- 1) + 2)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
-- 단일행 서브쿼리 : 서브쿼리의 조회결과 행 개수가 1개일 때
-- 일반적으로 단일행 서브쿼리 앞에는 일반연산자 사용
-- 노옹철 사원의 급여보다 많이 받는 직원의 사번, 이름, 부서코드, 직급코드, 급여 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- 전 직원의 평균 급여보다 적은 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                 FROM EMPLOYEE)
ORDER BY JOB_CODE;

-- 가장 적은 급여를 받는 직원의 사번, 이름, 직급코드, 부서코드, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
        FROM EMPLOYEE);

-- 부서별 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계 조회 (중요!!)
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
                      
-- 다중행 서브쿼리 : 서브쿼리의 조회 결과 행 개수가 여러 개일 때
-- IN/NOT IN : 여러 개의 결과 값 중에서 1개라도 일치하는 값이 있다면/없다면
-- > ANY, < ANY : 여러 개의 결과값 중에서 한 개라도 큰/작은 경우
--                  가장 작은 값보다 큰지 / 가장 큰 값보다 작은지
-- > ALL, < ALL : 모든 값보다 큰/작은 경우
--              가장 큰 값보다 큰지 / 가장 작은 값보다 작은지

-- 부서 별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT(MAX(SALARY))
                FROM EMPLOYEE
                GROUP BY DEPT_CODE);

-- 관리자와 일반 직원에 해당하는 사원 정보 추출 : 사번, 이름, 부서명, 직급, 구분(관리자/직원)
-- 1) 관리자에 해당하는 사원 번호
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 관리자에 해당하는 정보 추출
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '관리자' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL);
-- 3) 관리자에 해당하지 않는 사원 정보 추출
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '직원' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL);

-- 2) + 3)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '관리자' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, '직원' 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL);



SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
        CASE WHEN EMP_ID IN(SELECT DISTINCT MANAGER_ID
                            FROM EMPLOYEE
                            WHERE MANAGER_ID IS NOT NULL) THEN '관리자'
                                                          ELSE '직원'
        END 구분
FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
    JOIN JOB USING(JOB_CODE);
-- 오류

-- 대리 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의 사번,이름,직급,급여조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > (SELECT MIN(SALARY)
                    FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY(SELECT SALARY
                    FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');
                    
-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 사번,이름,직급,급여
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
    AND SALARY > ANY(SELECT MAX(SALARY)
                    FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '차장');
                    
                    SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
    AND SALARY > ALL(SELECT SALARY
                    FROM EMPLOYEE
                        JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '차장');
                    
                    
-- 다중열 서브쿼리 : 서브쿼리의 SELECT절에 나열된 항목 수가 여러 개일 때
-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원 이름,직급코드,부서코드,입사일조회
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE SUBSTR(EMP_NO,INSTR(EMP_NO, '-')+1 ,1) = 2
                    AND ENT_YN = 'Y')
        AND JOB_CODE = (SELECT JOB_CODE
                        FROM EMPLOYEE
                        WHERE SUBSTR(EMP_NO,INSTR(EMP_NO, '-')+1 ,1) = 2
                                AND ENT_YN = 'Y')
        AND EMP_NAME != (SELECT EMP_NAME
                         FROM EMPLOYEE
                         WHERE SUBSTR(EMP_NO,INSTR(EMP_NO, '-')+1 ,1) = 2
                                AND ENT_YN = 'Y');
                                

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                    FROM EMPLOYEE
                    WHERE SUBSTR(EMP_NO,INSTR(EMP_NO, '-')+1 ,1) = 2
                    AND ENT_YN = 'Y')
        AND EMP_NAME != (SELECT EMP_NAME
                         FROM EMPLOYEE
                         WHERE SUBSTR(EMP_NO,INSTR(EMP_NO, '-')+1 ,1) = 2
                                AND ENT_YN = 'Y');



-- 다중행 다중열 서브쿼리
-- 자기 직급의 평균 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여 조회
-- 단, 급여 평균은 십만원 단위로 계산 : TRUNC(컬럼명, -5)

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE;
-- 1) 직급별 평균 급여
SELECT JOB_CODE, TRUNC(AVG(SALARY), -5)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 2) 자기 직급의 평균 급여를 받고 있는 사원
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -5)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);




-- 인라인 뷰(INLINE-VIEW) : FROM절에 서브쿼리 사용
-- 전 직원 중 급여가 높은 상위 5명의 순위, 이름, 급여
SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE;

SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;


-- 급여 평균 3위 안에 드는 부서의 부서코드와 부서명, 평균 급여 조회
SELECT DEPT_CODE, DEPT_TITLE, 평균급여
FROM (SELECT DEPT_CODE, DEPT_TITLE, AVG(SALARY) 평균급여
      FROM EMPLOYEE
              LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
      GROUP BY DEPT_CODE, DEPT_TITLE
      ORDER BY AVG(SALARY) DESC)
WHERE ROWNUM <= 3;


-- RANK() OVER : 같은 값을 가질 때 순위를 건너뛰고
-- DENSE_RANK() OVER : 같은 값을 가질 때 순위는 건너뛰지 않고 순서대로
SELECT RANK() OVER(ORDER BY SALARY DESC) "RANK", 
        EMP_NAME, SALARY,
        DENSE_RANK() OVER(ORDER BY SALARY DESC) "DENSE"
FROM EMPLOYEE;


-- WITH : 서브쿼리에 이름을 붙여 사용 시 이름을 쓰게 함
SELECT ROWNUM, EMP_NAME, SALARY
FROM(SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC);
    
WITH DESC_SALARY AS (SELECT EMP_NAME, SALARY
                    FROM EMPLOYEE
                    ORDER BY SALARY DESC)
SELECT ROWNUM, EMP_NAME, SALARY
FROM DESC_SALARY;


-- 급여 평균 3위 안에 드는 부서의 부서코드와 부서명, 평균 급여 조회
WITH AVG_SAL AS (SELECT DEPT_CODE, DEPT_TITLE, AVG(SALARY)
                FROM EMPLOYEE
                    LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
                GROUP BY DEPT_CODE, DEPT_TITLE
                ORDER BY AVG(SALARY) DESC)
SELECT DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE;
--미완성



