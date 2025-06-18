SELECT * FROM project_medical_data_history.patients;

-- Show first name, last name, and gender of patients who's gender is 'M'
select first_name,last_name,gender from patients where gender='m';

-- Show first name and last name of patients who does not have allergies.
select first_name,last_name from patients where allergies is null;

-- Show first name of patients that start with the letter 'C'
select first_name from patients where first_name like 'C%';

--  Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name,last_name from patients where weight between 100 and 120;

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients set allergies='NKA' where allergies is null;

-- Show first name and last name concatenated into one column to show their full name.
select concat(first_name,' ',last_name) as full_name from patients;

-- Show first name, last name, and the full province name of each patient.
select first_name,last_name,province_name from patients as p join province_names as pn on p.province_id=pn.province_id;

-- Show how many patients have a birth_date with 2010 as the birth year.
select count(birth_date) from patients where birth_date like "2010%";

-- Show the first_name, last_name, and height of the patient with the greatest height.
select first_name,last_name,max(height) from patients group by first_name,last_name order by max(height) desc limit 1;

--  Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select * from patients where patient_id in (1,45,534,879,1000);

-- Show the total number of admissions
select count(patient_id) from admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day
select * from admissions where admission_date=discharge_date;

-- Show the total number of admissions for patient_id 579.
select count(*) from admissions where patient_id=579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct(city) from patients where province_id='NS';

-- Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name,last_name,birth_date from patients where height>160 and weight>70;

-- Show unique birth years from patients and order them by ascending.
select distinct(year(birth_date)) from patients order by year(birth_date) asc;

-- Show unique first names from the patients table which only occurs once in the list.
select first_name from patients group by first_name having count(*)=1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id,first_name from patients where first_name like "s%s" and length(first_name)>=6;

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
select p.patient_id,first_name,last_name from patients p inner join admissions a on p.patient_id=a.patient_id
where a.diagnosis='Dementia';

-- Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select first_name from patients order by length(first_name),first_name asc;

-- Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select (select count(*) from patients where gender='m') as total_males,
(select count(*) from patients where gender='f') as total_females;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id,diagnosis from admissions group by patient_id,diagnosis having count(*)>1;

-- Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select city,count(*) as patient_count from patients group by city order by patient_count desc,city asc;

-- Show first name, last name and role of every person that is either patient or doctor.The roles are either "Patient" or "Doctor"
select first_name,last_name,'patient' as role from patients 
union select first_name,last_name,'doctor' as role from doctors;

-- Show all allergies ordered by popularity. Remove NULL values from query.
select allergies,count(*) as count from patients where allergies is not null group by allergies order by count desc;

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name,last_name,birth_date from patients where year(birth_date) between 1970 and 1979;

/* We want to display each patient's full name in a single column. 
Their last_name in all upper letters must appear first, then first_name in all lower case letters. 
Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane */
select concat(upper(last_name),' ',lower(first_name)) as full_name from patients order by first_name desc;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id,sum(height) as total_height from patients group by province_id having total_height>=7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight)-min(weight) as weight_difference from patients where last_name='maroni';

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) as day,count(*) as admissions from admissions group by day order by admissions desc;

/* Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. 
if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc. */
select floor(weight/10)*10 as weight_group,
count(*) as total_patients from patients group by weight_group order by weight_group desc;

/* Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. 
Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm. */
select patient_id,weight,height,
case when weight/ power(height/100,2)>=30 then 1 else 0 end as isobese from patients;

/* Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis 
as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.*/
select p.patient_id,p.first_name,p.last_name,d.specialty from patients p join admissions a on p.patient_id=a.patient_id
join doctors d on a.attending_doctor_id=d.doctor_id where a.diagnosis='epilepsy' and d.first_name ='lisa';

/* All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

   The password must be the following, in order:
    - patient_id
    - the numerical length of patient's last_name
    - year of patient's birth_date */
    select patient_id,concat(patient_id,length(last_name),year(birth_date)) as temp_password from patients where patient_id
    in (select distinct patient_id from admissions);



