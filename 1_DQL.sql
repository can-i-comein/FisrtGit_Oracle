--SELECT
-- EMPLOYEE테이블에 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE;

-- 모든 정보 조회
SELECT * FROM EMPLOYEE;

-- JOB테이블의 직급 이름 조회
SELECT JOB_NAME FROM JOB;
-- DEPARTMENT테이블의 모든 정보 조회
SELECT * FROM DEPARTMENT;
-- EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;
-- EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY FROM EMPLOYEE;

--칼럼 값 산술 연산
-- EMPLOYEE테이블에서 직원명, 연봉 조회 (연봉 = 급여 * 12)
SELECT EMP_NAME, SALARY*12 FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명, 연봉, 보너스를 추가한 연봉
SELECT EMP_NAME, SALARY*12 + BONUS FROM EMPLOYEE;

--EMPLOYEE테이블에서 이름, 고용일, 근무일수(= 오늘날짜 SYSDATE) 조회
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE FROM employee;

-- 컬럼 별칭
-- 1. 컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭" / 컬럼명 별칭
-- ""은 별칭에 특수문자가 포함되거나 숫자로 시작할 경우 사용
SELECT EMP_NAME 이름, SALARY*12 "연봉(원)", SALARY*12 + BONUS "보너스를 추가한 연봉" 
FROM EMPLOYEE;

-- DISTINCT 중복 제거
SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE테이블에서 직원의 직급코드, 부서코드를 중복제거해서 조회
SELECT DISTINCT JOB_CODE, DEPT_CODE FROM EMPLOYEE;

-- WHERE절 : 조건 제시 절
-- = : 같다 / != ^= <> : 같지않다 
-- EMPLOYEE테이블에서 급여가 4000000 이상인 직원의 이름, 급여 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 4000000;

-- EMPLOYEE테이블에서 부서코드가 D9인 직원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE = 'D9';
-- EMPLOYEE테이블에서 부서코드가 D9가 아닌 사원의 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE != 'D9'; 
-- EMPLOYEE테이블에서 퇴사여부가 N인 직원을 조회하고 근무 여부를 재직중으로 표시하여
-- 사번, 이름, 고용일, 근무여부 조회
SELECT EMP_ID 사번, EMP_NAME 이름, HIRE_DATE 고용일, '재직중' 근무여부 
FROM EMPLOYEE WHERE ENT_YN = 'N';

-- EMPLOYEE 테이블에서 월급이 3000000이상인 사원의 이름, 월급, 고용일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE WHERE >= SALARY;

-- EMPLOYEE 테이블에서 SAL_LEVEL이 S1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE FROM EMPLOYEE WHERE SAL_LEVEL = 'S1';

-- EMPLOYEE 테이블에서 실수령액(총수령액 - (연봉*세금 3%))이 5천만원 이상인 사원의
-- 이름,월급, 실수령액, 고용일 조회
SELECT EMP_NAME, SALARY, 12*SALARY*(1+BONUS) - (12*SALARY*0.03) 실수령액 ,HIRE_DATE FROM EMPLOYEE
WHERE 12*SALARY - (SALARY*0.3) > 50000000;
/*
 실행 순서
 (WHERE에 SELECT에서 선언한 별칭을 사용할 수 없는 이유)
 5 SELECT
 1 FROM
 2 WHERE
 3 GROUP BY
 4 HAVING 
 6 ORDER BY
*/
-- EMPLOYEE 테이블에서 연봉이 45000000 초과인 사원의 이름, 월급, 연봉 조회
SELECT EMP_NAME, SALARY, 12*SALARY 연봉 FROM EMPLOYEE WHERE 12*SALARY > 45000000; 

-- EMPLOYEE 테이블에서 부서코드가 D6이고 급여를 3백만보다 많이 받는 직원 이름, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D6' AND SALARY > 3000000;

--EMPLOYEE 테이블에서 급여를 350만 이상 600이하를 받는 직원의 사번, 이름, 급여, 부서코드 ,직급코드 조회
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

-- EMPLOYEE 테이블에 월급이 400이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT * FROM EMPLOYEE 
WHERE SALARY >=4000000 AND JOB_CODE = 'J2';

-- EMPLOYEE 테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 고용일이 02년 1월1일보다 
-- 빠른 사원의 이름, 부서코드,고용일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5') AND HIRE_DAY < '02/01/01';

-- BETWEEN AND : 컬럼명 BETWEEN A AND B
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 350만 미만, 600만 초과
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE,JOB_CODE
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 6000000;

-- 90/01/01 ~ 01/01/01인 사원
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- LIKE : 비교하려는 값이 특정 패턴을 만족하는지 검사
-- 컬럼명 LIKE '문자패턴'
-- % : 0글자 이상 / _ : 1글자
-- '글자%' : 글자로 시작하는 값
-- '%글자' : 글자로 끝나는 값
-- '글%자' : 글로 시작해서 자로 끝나는 값 
-- '%글자%' : 글자를 포함하는 값
-- _ : 한글자
-- __ : 두글자
-- ___ : 세글자

-- EMPLOYEE 테이블에서 성이 전씨인 사원의 사번, 이름, 고용일
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE EMP_NAME LIKE '전%';

-- 이름에 '하'가 포함된 이름, 주민번호, 부서코드
SELECT EMP_NAME, EMP_NO, DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '%하%';

-- 전화번호 4번째 자리가 9로 시작하는 사원의 사번, 이름, 전화번호
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE LIKE '___9%';

--EMPLOYEE 테이블에서 이메일 중 _의 앞 글자가 3자리인 이메일 주소를 가진 사원의 사번,이름,이메일
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '____%';
-- ESCAPE OPTION : 검색하고자 하는 데이터와 패턴이 일치하는 경우 어떤 것이 패턴이고 
-- 특수문자인지 구분하지 못하기 때문에 데이터로 처리할 기호 앞에 임의의 문자를 사용해서
-- ESCAPE OPTION 등록
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '___!_%' ESCAPE '!';

-- 김씨 성이 아닌 직원 사번, 이름, 고용일
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE EMP_NAME NOT LIKE '김%';

-- 1. 이름 끝이 '연'으로 끝나는 사원 이름
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '%연';
-- 2. 전화번호 처음 3자리가 010이 아닌 사원 이름, 전화번호
SELECT EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE NOT LIKE '010%';
-- 3. 메일주소 '_'의 앞이 4자리면서 DEPT_CODE가 D9 또는 D6이고 
-- 고용일이 90/01/01 ~ 00/12/01이고, 급여가 270이상인 사원 전체조회

SELECT * 
FROM EMPLOYEE 
WHERE EMAIL LIKE '____!_%' ESCAPE '!'
AND (DEPT_CODE = 'D9' OR DEPT_CODE = 'D6') 
AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01' 
AND SALARY >= 2700000;

-- IS NULL / IS NOT NULL
-- EMPLOYEE테이블에서 보너스를 받지 않는 사원 사번, 이름, 급여, 보너스
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- 관리자도 없고 부서 배치도 받지 않은 직원 이름, 관리자, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE FROM EMPLOYEE 
WHERE MANAGER_ID IS NULL
AND DEPT_CODE IS NULL;
-- 부서 배치를 받지 않았지만 보너스를 지급받는 직원 이름, 보너스, 부서코드
SELECT EMP_NAME, BONUS, DEPT_CODE FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

-- IN
-- D6 부서와 D9 부서원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6','D9');
-- 직급코드가 J1,J2,J3,J4인 사람들의 이름, 직급코드, 급여
SELECT EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE 
WHERE JOB_CODE IN ('J1','J2','J3','J4');

-- 연결 연산자 ||
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

SELECT EMP_NAME || '님의 월급은 ' || SALARY || '원입니다.'
FROM EMPLOYEE;


-- J7 또는 J2 직급의 급여 200만원 이상 받는 직원의 직원 이름, 급여,직급코드
SELECT EMP_NAME 이름, SALARY, JOB_CODE FROM EMPLOYEE 
WHERE JOB_CODE IN ('J2', 'J7')
AND SALARY >= 2000000
ORDER BY 이름 DESC;







