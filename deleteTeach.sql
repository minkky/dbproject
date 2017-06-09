CREATE OR Replace PROCEDURE DeleteTeach (pProfessorId IN VARCHAR2, 
		sCourseId IN VARCHAR2, 
		nCourseIdNo IN NUMBER,
		result	OUT VARCHAR2)
IS
BEGIN
	result := '';

	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(pProfessorId || '���� �����ȣ ' || sCourseId || ', �й� ' || TO_CHAR(nCourseIdNo) || '�� ���� ������ ��û�Ͽ����ϴ�.');

	DELETE
	FROM teach
	WHERE p_id = pProfessorId and c_id = sCourseId and c_id_no = nCourseIdNo;

	COMMIT;
	result := '���� ������ �Ϸ�Ǿ����ϴ�.';

EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		result := SQLCODE;
END;
/