--GROUP BY / HAVING
-- GROUP BY : 그룹함수에 대해서 컬럼을 그룹으로 묶고자 할 때
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- EMPLOYEE테이블에서 부서 코드 별 그룹을 지정하여 
-- 부서코드, 그룹별 급여 합계, 그룹별 급여 평균, 인원 수 조회(부서코드 순 정렬)

-- EMPLOYEE 테이블에서 부서코드와 보너스를 받는 사원 수 조회 (부서코드 순)

-- EMPLOYEE 테이블에서 직급코드와 보너스를 받는 사원 수 조회 (직급코드 순)