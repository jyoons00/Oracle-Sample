-- SCOTT
-- 설문조사 DB 모델링 (팀)

-- 초기 INSERT 값 집어 넣기
CREATE SEQUENCE seq_tblsurvey
NOCACHE;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 예쁜 아이돌은?','관리자','2023-05-01','2023-06-01',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '슬기');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '예나');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '아이린');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 잘생긴 아이돌은?','관리자','2023-05-12','2023-06-12',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '차은우');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '육성재');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '유노윤호');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '최강창민');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 잘생긴 배우는?','관리자','2024-07-28','2024-08-28',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '김수현');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '이정재');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '이병헌');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '오달수');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 5, '마동석');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'가장 예쁜 배우는?','관리자','2024-08-19','2024-09-19',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '김태희');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '김지원');
COMMIT;



-- 1) 최신 설문조사 질문과 문항 출력하는 쿼리
select s_no,s_quest
from tbl_survey
where s_no in ( select max(s_no)
from tbl_survey);

select q_no,q_item
from tbl_quest
where s_no = 1;



--2) 설문 목록을 아래와 같이 출력하는 쿼리 작성
SELECT
	s.S_NO AS 번호,
	s.S_QUEST AS 질문,
	s.S_NAME AS 작성자,
	s.S_STARTDATE AS 시작일,
	s.S_LASTDATE AS 종료일,
	(SELECT COUNT(*) FROM SCOTT.TBL_QUEST q WHERE q.S_NO = s.S_NO) 항목수,
	(SELECT COUNT(DISTINCT a.U_ID) FROM SCOTT.TBL_ANSWER a WHERE a.S_NO = s.S_NO) 참여자수,
	CASE 
		WHEN s.S_STARTDATE <= SYSDATE AND SYSDATE <= s.S_LASTDATE 
		THEN '진행중'
		WHEN SYSDATE > s.S_LASTDATE THEN '종료'
		ELSE '미시작'
		END AS 상태
	FROM SCOTT.TBL_SURVEY s
	ORDER BY S.S_NO DESC;
	CASE



-- 3) 입력한 설문 작성하는 쿼리

-- 시퀸스 생성
   CREATE SEQUENCE seq_tblsurvey
   NOCACHE;

-- 설문 작성하는 쿼리
    INSERT INTO tbl_survey VALUES(seq_tblsurvey.NEXTVAL
    ,'가장 예쁜 아이돌은?','관리자','2023-05-01','2023-06-01',SYSDATE);
    INSERT INTO tbl_quest VALUES(seq_tblsurvey.CURRVAL, 1, '슬기');
    INSERT INTO tbl_quest VALUES(seq_tblsurvey.CURRVAL, 2, '예나');
    INSERT INTO tbl_quest VALUES(seq_tblsurvey.CURRVAL, 3, '아이린');
    COMMIT;



-- 4) 설문 목록에서 하나의 설문을 선택해서 선택한 설문 내용 출력하는 쿼리
SELECT DISTINCT
	s.s_quest,
	s.s_name,
	s.s_writedate,
	s.s_startdate,
	s.s_lastdate,
	CASE
		WHEN s.s_startdate <= SYSDATE AND SYSDATE <= s.s_lastdate THEN '진행중'
		WHEN SYSDATE > s.s_lastdate THEN '종료'
		ELSE '미시작' 
	END AS 상태,
	(SELECT COUNT(q_item) FROM tbl_quest WHERE s_no = 1) AS 항목수
FROM tbl_survey s JOIN tbl_quest q ON s.s_no = q.s_no
WHERE s.s_no = 1;

-- 보기 보이게
SELECT q_no,q_item
FROM tbl_quest q
WHERE s_no = 1
ORDER BY q_no;



-- 5) 총 참여자 수 조회하는 쿼리
SELECT COUNT(*) 총참여자수
FROM tbl_answer
WHERE s_no = 1;



-- 6) 투표하기 관련 쿼리
INSERT INTO TBL_ANSWER VALUES(1, 'asd3',  3, SYSDATE);
COMMIT;



-- 7) 현재 설문 결과를 그래프로 나타내는 쿼리
SELECT
b.q_no,
b.q_item
,LPAD( RPAD(' ', 100-(RATIO_TO_REPORT(count(a_no)) OVER()100)),100, '')그래프
,COUNT(a.a_no) AS 답변수
,round(RATIO_TO_REPORT(count(a_no)) OVER()*100,2) || '%' as percent
FROM
tbl_quest b
LEFT JOIN
tbl_answer a ON b.s_no = a.s_no AND b.q_no = a.a_no
WHERE
b.s_no = 1
GROUP BY
b.q_no, b.q_item
ORDER BY
b.q_no, b.q_item;



-- 8) 관리자가 설문 수정하는 쿼리

-- 종료일 수정
UPDATE tbl_survey 
SET s_lastdate = TO_DATE('24/08/26')
WHERE s_no = 3;

-- 항목 수정
UPDATE tbl_quest
SET q_item = '윤아'
WHERE s_no = 1 AND q_no = 1;



-- 9) 관리자가 설문 삭제하는 쿼리
DELETE
FROM tbl_survey
WHERE s_no = 1;




