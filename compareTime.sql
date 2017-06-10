CREATE OR REPLACE FUNCTION compareTime (
	first_course_id VARCHAR,
	first_course_id_no NUMBER,
	second_course_id VARCHAR,
	second_course_id_no NUMBER
)
RETURN NUMBER
IS
	overlap NUMBER;
	first_course_day NUMBER;
	first_start_hour NUMBER;
	first_start_minute NUMBER; 
	first_end_hour NUMBER;
	first_end_minute NUMBER; 
	second_course_day NUMBER;
	second_start_hour NUMBER;
	second_start_minute NUMBER;
	second_end_hour NUMBER;
	second_end_minute NUMBER;	
BEGIN
	SELECT t_day, t_startTime_HH, t_startTime_MM, t_endTime_HH, t_endTime_MM 
	INTO first_course_day, first_start_hour, first_start_minute, first_end_hour, first_end_minute
	FROM teach
	WHERE first_course_id = c_id and first_course_id_no = c_id_no;

	SELECT t_day, t_startTime_HH, t_startTime_MM, t_endTime_HH, t_endTime_MM 
	INTO second_course_day, second_start_hour, second_start_minute, second_end_hour, second_end_minute
	FROM teach
	WHERE second_course_id = c_id and second_course_id_no = c_id_no;

	overlap := 0;
	
	IF (first_course_day = second_course_day) THEN
		IF (first_end_hour >= second_start_hour AND first_end_minute >= second_start_minute) THEN
			IF (first_start_hour <= second_end_hour AND first_start_minute <= second_end_minute) THEN
				overlap := 1;
			END IF;
		ELSIF (first_end_hour <= second_start_hour AND first_end_minute <= second_start_minute) THEN
			IF (first_start_hour >= second_end_hour AND first_start_minute >= second_end_minute) THEN
				overlap := 1;
			END IF;
		END IF;
	END IF;
	COMMIT;
RETURN overlap;
END;
/