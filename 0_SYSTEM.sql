-- 한줄 주석
/*
여러줄 주석
*/

-- ~11G버전 : CREATE USER KH IDENTIFIED BY KH;
-- 12C~버전 : CREATE USER C##KH IDENTIFIED BY KH;
CREATE USER C##KH IDENTIFIED BY KH;
DROP USER C##kh;
-- sql은 대소문자 상관x (비밀번호 제외, 리터럴값 제외)

alter session set "_oracle_script" = true;
create user kh identified by kh;

-- 관리자 계정 : 데이터베이스의 생성과 관리를 담당하고 있는 슈퍼 유저 계정
--             오브젝트 생성, 변경, 삭제 등의 작업이 가능하며
--             데이터베이스에 대한 모든 권한과 책임을 가지는 계정
-- 사용자 계정 : 데이터베이스에 대하여 질의, 갱신 등의 작업을 수행할 수 있는 계정
--             일반 계정은 보안을 위해 업무에 필요한 최소한의 권한만 가지는 것을 원칙으로 함

GRANT CONNECT, RESOURCE TO KH;
ALTER USER KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER USER KH DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;


-------------------------------------------------------------------
CREATE USER C##SCOTT IDENTIFIED BY SCOTT;
DROP USER C##SCOTT;

alter session set "_oracle_script" = true;
create user SCOTT identified by SCOTT;


GRANT CONNECT, RESOURCE TO SCOTT;
ALTER USER SCOTT DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
ALTER USER SCOTT DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;