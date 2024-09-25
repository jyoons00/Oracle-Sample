-- SCOTT
-- �������� DB �𵨸� (��)

-- �ʱ� INSERT �� ���� �ֱ�
CREATE SEQUENCE seq_tblsurvey
NOCACHE;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� ���� ���̵���?','������','2023-05-01','2023-06-01',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '���̸�');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� �߻��� ���̵���?','������','2023-05-12','2023-06-12',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '������ȣ');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '�ְ�â��');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� �߻��� ����?','������','2024-07-28','2024-08-28',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '�����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '�̺���');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '���޼�');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 5, '������');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tblSURVEY.NEXTVAL,'���� ���� ����?','������','2024-08-19','2024-09-19',SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
COMMIT;



-- 1) �ֽ� �������� ������ ���� ����ϴ� ����
select s_no,s_quest
from tbl_survey
where s_no in ( select max(s_no)
from tbl_survey);

select q_no,q_item
from tbl_quest
where s_no = 1;



--2) ���� ����� �Ʒ��� ���� ����ϴ� ���� �ۼ�
SELECT
	s.S_NO AS ��ȣ,
	s.S_QUEST AS ����,
	s.S_NAME AS �ۼ���,
	s.S_STARTDATE AS ������,
	s.S_LASTDATE AS ������,
	(SELECT COUNT(*) FROM SCOTT.TBL_QUEST q WHERE q.S_NO = s.S_NO) �׸��,
	(SELECT COUNT(DISTINCT a.U_ID) FROM SCOTT.TBL_ANSWER a WHERE a.S_NO = s.S_NO) �����ڼ�,
	CASE 
		WHEN s.S_STARTDATE <= SYSDATE AND SYSDATE <= s.S_LASTDATE 
		THEN '������'
		WHEN SYSDATE > s.S_LASTDATE THEN '����'
		ELSE '�̽���'
		END AS ����
	FROM SCOTT.TBL_SURVEY s
	ORDER BY S.S_NO DESC;
	CASE



-- 3) �Է��� ���� �ۼ��ϴ� ����

-- ������ ����
   CREATE SEQUENCE seq_tblsurvey
   NOCACHE;

-- ���� �ۼ��ϴ� ����
    INSERT INTO tbl_survey VALUES(seq_tblsurvey.NEXTVAL
    ,'���� ���� ���̵���?','������','2023-05-01','2023-06-01',SYSDATE);
    INSERT INTO tbl_quest VALUES(seq_tblsurvey.CURRVAL, 1, '����');
    INSERT INTO tbl_quest VALUES(seq_tblsurvey.CURRVAL, 2, '����');
    INSERT INTO tbl_quest VALUES(seq_tblsurvey.CURRVAL, 3, '���̸�');
    COMMIT;



-- 4) ���� ��Ͽ��� �ϳ��� ������ �����ؼ� ������ ���� ���� ����ϴ� ����
SELECT DISTINCT
	s.s_quest,
	s.s_name,
	s.s_writedate,
	s.s_startdate,
	s.s_lastdate,
	CASE
		WHEN s.s_startdate <= SYSDATE AND SYSDATE <= s.s_lastdate THEN '������'
		WHEN SYSDATE > s.s_lastdate THEN '����'
		ELSE '�̽���' 
	END AS ����,
	(SELECT COUNT(q_item) FROM tbl_quest WHERE s_no = 1) AS �׸��
FROM tbl_survey s JOIN tbl_quest q ON s.s_no = q.s_no
WHERE s.s_no = 1;

-- ���� ���̰�
SELECT q_no,q_item
FROM tbl_quest q
WHERE s_no = 1
ORDER BY q_no;



-- 5) �� ������ �� ��ȸ�ϴ� ����
SELECT COUNT(*) �������ڼ�
FROM tbl_answer
WHERE s_no = 1;



-- 6) ��ǥ�ϱ� ���� ����
INSERT INTO TBL_ANSWER VALUES(1, 'asd3',  3, SYSDATE);
COMMIT;



-- 7) ���� ���� ����� �׷����� ��Ÿ���� ����
SELECT
b.q_no,
b.q_item
,LPAD( RPAD(' ', 100-(RATIO_TO_REPORT(count(a_no)) OVER()100)),100, '')�׷���
,COUNT(a.a_no) AS �亯��
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



-- 8) �����ڰ� ���� �����ϴ� ����

-- ������ ����
UPDATE tbl_survey 
SET s_lastdate = TO_DATE('24/08/26')
WHERE s_no = 3;

-- �׸� ����
UPDATE tbl_quest
SET q_item = '����'
WHERE s_no = 1 AND q_no = 1;



-- 9) �����ڰ� ���� �����ϴ� ����
DELETE
FROM tbl_survey
WHERE s_no = 1;




