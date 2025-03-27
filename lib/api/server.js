const express = require('express');
const app = express();
const { Client } = require('pg');
const bcrypt = require('bcryptjs'); // Import bcrypt
const cors = require('cors');
const e = require('express');
const port = 54422; // Port where the API will run

// Middleware
app.use(cors());
app.use(express.json()); // Use Express's built-in JSON parser

// PostgreSQL Client
const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'studentSystemDb',
  password: 'pc#2024',
  port: 5432,
});

// Connect to PostgreSQL
client.connect((err) => {
  if (err) {
    console.error('Connection error', err.stack);
  } else {
    console.log('Connected to PostgreSQL');
  }
});

// Admissions Route
app.post('/admission/Courses', async (req, res) => {
  let { courseType } = req.body;

  console.log("Received course type of :", courseType); 
  
  try {
    if (courseType === 'Бакалавр/evening') {
      const majors_type = 'орой';
      result = await client.query('SELECT major_id, major_name, majors_description FROM major WHERE majors_type = $1', [majors_type]);
    } else {  
      result = await client.query('SELECT major_id, major_name, majors_description FROM major WHERE academic_degree = $1', [courseType]);
    }
    if (result.rows.length === 0) {
      return res.status(400).json({ message: 'Course type does not exits!' });
    } else {
      const majors = result.rows;
      console.log(majors);
      return res.status(200).json({ message: 'Courses Pull Successful!', majors });
    } 
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});

//Major Introduction
app.post('/admission/Courses/Introduction', async (req, res) => {
  let { major_id } = req.body;
  console.log("Received majorId of :", major_id); 
  
  try {
      result = await client.query('SELECT * FROM major WHERE major_id = $1', [major_id]);
    if (result.length === 0) {
      return res.status(400).json({ message: 'Course does not exits!' });
    } else {
      const major = result.rows[0];
      return res.status(200).json({ message: 'Course Pull Successful!', major });
    } 
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});


//Student Signup
app.post('/admission/Courses/Introduction/Student/Signup', async (req, res) => {
  let { major_id } = req.body;
  console.log("Received majorId of :", major_id); 
  console.log(req);
  try {
      result = await client.query('SELECT * FROM major WHERE major_id = $1', [major_id]);
    if (result.length === 0) {
      return res.status(400).json({ message: 'Course does not exits!' });
    } else {
      const major = result.rows;
      return res.status(200).json({ message: 'Course Pull Successful!', major });
    } 
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});

// Validate exam scores
app.post('/User/Signup/Validating', async (req, res) => {
  let { email, password } = req.body;
  console.log("Received email of :", email); 
 
  return res.status(200).json({ message: 'Сурагчийн шалгалт!',
    exam_json:
    {
      "user_name": "Aриун",
      "user_sirname": "Болд",
      "registry_number": "УП03231416",
      "exam_code": "S12345",
      "email": "example3@.com",
      "exams": [
        {
          "exam_type": "Математик",
          "score": 500.0
        },
        {
          "exam_type": "Англи хэл",
          "score": 756.0
        }
      ],
      "created_at": "2024-06-01T14:00:00Z",
      "valid_until": "2025-06-01T14:00:00Z",
    }
  });
   
});


app.post('/User/Staff/Signup/Validating', async (req, res) => {
  let { registryNumber } = req.body;
  console.log("Received registrynumber of :", registryNumber); 
 
  return res.status(200).json({ message: 'Иргэний мэдээлэл!',
    user_json:
    {
      "user_name": "Болд",
      "user_sirname": "Баатар",
      "registry_number": "ЙР74020163",
      "email": "citizen1@.com",
      "education": "Дээд",
      "academic_degree": "Бакалавр",
      "profession": "Багш"
    }
  });
   
});


app.post('/User/Signup/GetInfoOfRegistryNumber', async (req, res) => {
  let { registryNumber, userRole } = req.body;
  console.log("Received registryNumber of:", registryNumber);

  try {
  
    return res.status(200).json({
        firstName: "Aриун",
        lastName: "Болд",
        dateOfBirth: "2025-02-07",
        gender: "эрэгтэй",
        nationality: "Монгол",
        province: "Архангай",
        district: "Бат-Өлзий",
        city: "Улаанбаатар",
        birthProvince: "Архангай",
        birthDistrict: "Бат-Өлзий",
        birthCity: "Чулуун Овоот",
        addressStatus: "байхгүй",
        phoneNumber1: "80179496",
        phoneNumber2: "80174996",
        phoneNumber3: "80179496",
        country: "Canada",
        ethnicity: "Халх",
        isMarried: "т",
        emailProvider: "Мелбөүрнэ",
        isWorking: "т",
        isFullTime: "т",
        educationLevel: "Ахлах",
        specialization: "*",
        additionalInfo1: null,
        additionalInfo2: "*",
        additionalInfo3: null,
        maritalStatus: "Гэрлээгүй",
        hasChildren: "Үгүй",
        hasSiblings: "Үгүй",
        additionalNotes: null,
        bloodType: "O+",
        bloodGroup: "B",
        medicalHistory: null,
        hasDisabilities: "Үгүй",
        isStudent: true,
        email: "example2@.com"
      
    });
  } catch (e) {
    console.error('Database query error:', e);
    res.status(500).json({
      message: 'Error querying the database',
      error: e.message
    });
  }
});

// Student User Level Creation 
app.post('/User/Signup/Create/User', async (req, res) => {

  let {
    registryNumber,
    profilePicture,
    fname,
    lname,
    major,
    email,
    userRole,
    birthday,
    familyTreeName,
    citizenship,
    validAddress,
    homePhoneNumber,
    validAddressLiving,
    postalAddress,
    phoneNumber,
    phoneNumberEmergency,
    placeOfBirth,
    socialBackground,
    townDistrictOfBirth,
    stateCityOfBirth,
    ethnicity,
    profession,
    passportNumber,
    driversCertificateNumber,
    additionalDescription,
    selectedGender,
    selectedCityOrState,
    selectedDistrictOrTown,
    selectedCountry,
    selectedEducation,
    selectedAcademicDegree,
    militaryService,
    bloodType,
    driversLicenseType,
    married,
    pensionsEstablished,
    disabled,
    createdAt,
    signature,
    branchSchool,
    jobPost
  } = req.body;
  
  const createdAtString = new Date().toISOString(); 

  try {
    // Check if the registryNumber already exists in the database
    const result = await client.query(
      'SELECT COUNT(*) FROM auth_user WHERE registry_number = $1', 
      [registryNumber]
    );

    if (result.rows[0].count === '0') {
      
      let department_code = await client.query(
        'SELECT ' + 
          'department.department_code, ' + 
          'department.department_id ' +
        'FROM major ' + 
        'JOIN departmentsofeducation ' + 
          'ON major.department_of_edu_id = departmentsofeducation.departments_of_education_id ' + 
        'JOIN department ' + 
          'ON departmentsofeducation.departments_of_education_id = department.department_of_edu_id ' +  
        'WHERE major.department_of_edu_id = $1 ' +
        'LIMIT 1',
        [major.department_of_edu_id]
      );
      const dep_code = department_code.rows[0].department_code.toString().toLocaleLowerCase();
      const dep_id = department_code.rows[0].department_id;
      console.log(dep_id);

      enrollmentYear = new Date().getFullYear().toString();
      const students_count_of_year_and_major = await client.query(
        'SELECT ' + 
          'COUNT(*) AS count ' + 
        'FROM auth_user ' + 
        'WHERE login_name LIKE $1',
        [dep_code + enrollmentYear.slice(2) + 'с' + '%' ]
      );
      console.log(students_count_of_year_and_major);
      let loginName;
      const count = students_count_of_year_and_major.rows[0].count;
      const students_count = parseInt(count) + 1;
      const salt = await bcrypt.genSalt(10);
      let password_hash = await bcrypt.hash(registryNumber.slice(2), salt);

      if (students_count < 10) {
        loginName = dep_code + enrollmentYear.slice(2) + 'с' + '00' + students_count;
        console.log(loginName);
      }else if (students_count < 100 && students_count > 9 ) {
        loginName = dep_code + enrollmentYear.slice(2) + 'с' + '0' + students_count;
        console.log(loginName);
      }else if (students_count < 1000 && students_count > 99 ) {
        loginName = dep_code + enrollmentYear.slice(2) + 'с' + students_count;
        console.log(loginName);
      }
      
      console.log(loginName);
      
      const userData = {
        loginName: loginName,
        passwordHash: password_hash,
        profilePicture: profilePicture,  
        registryNumber: registryNumber,
        fname: fname,
        lname: lname,
        major: major,
        email: email,
        userRole: userRole,
        birthday: birthday,
        familyTreeName: familyTreeName,
        citizenship: citizenship,
        validAddress: validAddress,
        homePhoneNumber: homePhoneNumber,
        validAddressLiving: validAddressLiving,
        postalAddress: postalAddress,
        phoneNumber: phoneNumber,
        phoneNumberEmergency: phoneNumberEmergency,
        placeOfBirth: placeOfBirth,
        socialBackground: socialBackground,
        townDistrictOfBirth: townDistrictOfBirth,
        stateCityOfBirth: stateCityOfBirth,
        ethnicity: ethnicity,
        profession: profession,
        passportNumber: passportNumber,
        driversCertificateNumber: driversCertificateNumber,
        additionalDescription: additionalDescription,
        selectedGender: selectedGender,
        selectedCityOrState: selectedCityOrState,
        selectedDistrictOrTown: selectedDistrictOrTown,
        selectedCountry: selectedCountry,
        selectedEducation: selectedEducation,
        selectedAcademicDegree: selectedAcademicDegree,
        militaryService: militaryService,
        bloodType: bloodType,
        driversLicenseType: driversLicenseType,
        married: married,
        pensionsEstablished: pensionsEstablished,
        disabled: disabled,
        professionCertification: '*',
      };

      const userQuery = `
      INSERT INTO public.auth_user (
        login_name, password_hash, profile_picture, registry_number, user_role, fname, lname, 
        birthday, gender, citizenship, state_city, town_district, valid_address, state_city_living, 
        town_district_living, valid_address_living, postal_address, home_phone_number, phone_number, 
        phone_number_emergency, country, ethnicity, social_background, state_city_of_birth, 
        town_district_of_birth, place_of_birth, education, current_academic_degree, profession, 
        profession_certification, f_passport_number, married, military_service, pensions_established, 
        additional_notes, blood_type, drivers_certificate, drivers_certificate_number, disabled, is_active, 
        email
      ) 
      VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, 
        $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41
      ) RETURNING user_id, login_name, password_hash, user_role, registry_number;
      `;
      

      const userValues = [
        userData.loginName,
        userData.passwordHash,
        userData.profilePicture || null,
        userData.registryNumber,
        userData.userRole,
        userData.fname,
        userData.lname,
        userData.birthday,
        userData.selectedGender,
        userData.citizenship,
        userData.selectedCityOrState,  
        userData.selectedDistrictOrTown,
        userData.validAddress,
        userData.selectedCityOrState, 
        userData.selectedDistrictOrTown,  
        userData.validAddressLiving,
        userData.postalAddress || null,  
        userData.homePhoneNumber,
        userData.phoneNumber,
        userData.phoneNumberEmergency,
        userData.selectedCountry, 
        userData.ethnicity,
        userData.socialBackground,
        userData.stateCityOfBirth, 
        userData.townDistrictOfBirth,  
        userData.placeOfBirth,
        userData.selectedEducation, 
        userData.selectedAcademicDegree,  
        userData.profession || null,  
        userData.professionCertification || null,  
        userData.passportNumber || null,  
        userData.married,
        userData.militaryService,
        userData.pensionsEstablished || null,  
        userData.additionalDescription || null, 
        userData.bloodType || null, 
        userData.driversLicenseType || null, 
        userData.driversCertificateNumber || null,  
        userData.disabled,
        userData.isActive || true,  
        userData.email
      ];
      
      console.log(userQuery);
      console.log(userValues);
      const insertResult = await client.query(userQuery, userValues);

      const user = await client.query('SELECT user_id FROM auth_user WHERE login_name = $1', [loginName]);
      const userToStudent = user.rows[0];

      const userSignature = {
        userId: insertResult.rows[0].user_id,
        userRegistryNumber: insertResult.rows[0].registry_number,
        userRole: insertResult.rows[0].user_role,
        signature: signature,  
      };

      const signatureQuery = `
      INSERT INTO public.user_signatures (
        user_id, user_registry_number, user_role, signature
      ) 
      VALUES (
        $1, $2, $3, $4
      ) RETURNING user_signature_id, user_registry_number;
      `;
      
      const signatureValues = [
        userSignature.userId,
        userSignature.userRegistryNumber,
        userSignature.userRole,
        userSignature.signature
      ];
      const insertResultSignature = await client.query(signatureQuery, signatureValues);
      console.log(insertResultSignature.rows[0].user_registry_number);


      const student_email = loginName + '@studentsystem.mn';
      console.log(userToStudent, student_email);

      const studentData = {
        user_id: userToStudent.user_id,
        student_club_id: null,
        student_code: loginName,
        student_email: student_email,
        enrollment_number: count,
        enrollment_year: enrollmentYear,
        year_classification: '1-р курс',
        current_academic_degree: major.academic_degree,
        major_id: major.major_id,
        department_id: dep_id,
        };


        try {
          const studentQuery = `
            INSERT INTO public.student (
              user_id,
              student_club_id,
              student_code,
              student_email,
              enrollment_number,
              enrollment_year,
              year_classification,
              current_academic_degree,
              major_id,
              department_id
            )
            VALUES (
              $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
            )
            RETURNING student_id;
          `;
      
          const studentValues = [
            studentData.user_id,
            null,
            studentData.student_code,
            studentData.student_email,
            studentData.enrollment_number,
            studentData.enrollment_year,
            studentData.year_classification, 
            studentData.current_academic_degree,
            studentData.major_id,
            studentData.department_id,
          ];
      
          const result = await client.query(studentQuery, studentValues);
          console.log('Оюутан student_id:', result.rows[0].student_id);   
        }catch (error) {
          console.error(error);
          return res.status(500).json({
            message: 'Internal Server Error'
          });
        }

      return res.status(200).json({
        message: 'Хэрэглэгчийн бүртгэлийг үүсгэлээ!',
        user: (insertResult.rows[0].user_id, insertResult.rows[0].loginName, registryNumber.slice(2))
      });
  
    } else {
     
      return res.status(400).json({
        message: 'Энэ хэрэглэгч аль хэдийн бүртгэгдсэн байна.'
      });
    }
  
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Internal Server Error'
    });
  }
});


// Create User Level of Teacher
app.post('/User/Signup/Create/User/Teacher', async (req, res) => {
  let {
    registryNumber,
    profilePicture,
    fname,
    lname,
    major,
    email,
    userRole,
    birthday,
    familyTreeName,
    citizenship,
    validAddress,
    homePhoneNumber,
    validAddressLiving,
    postalAddress,
    phoneNumber,
    phoneNumberEmergency,
    placeOfBirth,
    socialBackground,
    townDistrictOfBirth,
    stateCityOfBirth,
    ethnicity,
    profession,
    passportNumber,
    driversCertificateNumber,
    additionalDescription,
    selectedGender,
    selectedCityOrState,
    selectedDistrictOrTown,
    selectedCountry,
    selectedEducation,
    selectedAcademicDegree,
    militaryService,
    bloodType,
    driversLicenseType,
    married,
    pensionsEstablished,
    disabled,
    createdAt,
    signature,
    branchSchool,
    departmenstOfEducation,
    jobPost,
  } = req.body;
  console.log(`Recieved teacher creation of: ${branchSchool}, ${jobPost} ${registryNumber} ${departmenstOfEducation}`);
  const createdAtString = new Date().toISOString(); 

  try {
    const result = await client.query(
      'SELECT COUNT(*) FROM auth_user WHERE registry_number = $1', 
      [registryNumber]
    );

    if (result.rows[0].count === '0') {
      
      const branches = await client.query(
        'SELECT departments_of_education_id FROM departmentsofeducation WHERE ed_department_name = $1', [branchSchool]
      );
      const branch_school_id = branches.rows[0].departments_of_education_id

      const dep = await client.query(
        'SELECT department_id, department_code FROM department WHERE department_name = $1', [departmenstOfEducation]
      );
      const departments = dep.rows[0].department_id
      const departments_code = dep.rows[0].department_code.toLocaleLowerCase();
      enrollmentYear = new Date().getFullYear().toString();

      const teachers_count_of_year_and_dep_of_edu = await client.query(
        'SELECT ' + 
          'COUNT(*) AS count ' + 
        'FROM auth_user ' + 
        'WHERE login_name LIKE $1',
        [departments_code + enrollmentYear.slice(2) + 'б' + '%' ]
      );
      
      let loginName;
      const count = teachers_count_of_year_and_dep_of_edu.rows[0].count;
      const teachers_count = parseInt(count) + 1;
      const salt = await bcrypt.genSalt(10);
      let password_hash = await bcrypt.hash(registryNumber.slice(2), salt);

      if (teachers_count < 10) {
        loginName = departments_code + enrollmentYear.slice(2) + 'б' + '00' + teachers_count;
        console.log(loginName);
      }else if (students_count < 100 && students_count > 9 ) {
        loginName = departments_code + enrollmentYear.slice(2) + 'б' + '0' + teachers_count;
        console.log(loginName);
      }else if (students_count < 1000 && students_count > 99 ) {
        loginName = departments_code + enrollmentYear.slice(2) + 'б' + '0' + teachers_count;
        console.log(loginName);
      }
      
      
      const userData = {
        loginName: loginName,
        passwordHash: password_hash,
        profilePicture: profilePicture,  
        registryNumber: registryNumber,
        fname: fname,
        lname: lname,
        major: major,
        email: email,
        userRole: userRole,
        birthday: birthday,
        familyTreeName: familyTreeName,
        citizenship: citizenship,
        validAddress: validAddress,
        homePhoneNumber: homePhoneNumber,
        validAddressLiving: validAddressLiving,
        postalAddress: postalAddress,
        phoneNumber: phoneNumber,
        phoneNumberEmergency: phoneNumberEmergency,
        placeOfBirth: placeOfBirth,
        socialBackground: socialBackground,
        townDistrictOfBirth: townDistrictOfBirth,
        stateCityOfBirth: stateCityOfBirth,
        ethnicity: ethnicity,
        profession: profession,
        passportNumber: passportNumber,
        driversCertificateNumber: driversCertificateNumber,
        additionalDescription: additionalDescription,
        selectedGender: selectedGender,
        selectedCityOrState: selectedCityOrState,
        selectedDistrictOrTown: selectedDistrictOrTown,
        selectedCountry: selectedCountry,
        selectedEducation: selectedEducation,
        selectedAcademicDegree: selectedAcademicDegree,
        militaryService: militaryService,
        bloodType: bloodType,
        driversLicenseType: driversLicenseType,
        married: married,
        pensionsEstablished: pensionsEstablished,
        disabled: disabled,
        professionCertification: '*',
        
      };

      const userQuery = `
      INSERT INTO public.auth_user (
        login_name, password_hash, profile_picture, registry_number, user_role, fname, lname, 
        birthday, gender, citizenship, state_city, town_district, valid_address, state_city_living, 
        town_district_living, valid_address_living, postal_address, home_phone_number, phone_number, 
        phone_number_emergency, country, ethnicity, social_background, state_city_of_birth, 
        town_district_of_birth, place_of_birth, education, current_academic_degree, profession, 
        profession_certification, f_passport_number, married, military_service, pensions_established, 
        additional_notes, blood_type, drivers_certificate, drivers_certificate_number, disabled, is_active, 
        email
      ) 
      VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, 
        $21, $22, $23, $24, $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40, $41
      ) RETURNING user_id, login_name, password_hash, user_role, registry_number;
      `;
      

      const userValues = [
        userData.loginName,
        userData.passwordHash,
        userData.profilePicture || null,
        userData.registryNumber,
        userData.userRole,
        userData.fname,
        userData.lname,
        userData.birthday,
        userData.selectedGender,
        userData.citizenship,
        userData.selectedCityOrState,  
        userData.selectedDistrictOrTown,
        userData.validAddress,
        userData.selectedCityOrState, 
        userData.selectedDistrictOrTown,  
        userData.validAddressLiving,
        userData.postalAddress || null,  
        userData.homePhoneNumber,
        userData.phoneNumber,
        userData.phoneNumberEmergency,
        userData.selectedCountry, 
        userData.ethnicity,
        userData.socialBackground,
        userData.stateCityOfBirth, 
        userData.townDistrictOfBirth,  
        userData.placeOfBirth,
        userData.selectedEducation, 
        userData.selectedAcademicDegree,  
        userData.profession || null,  
        userData.professionCertification || null,  
        userData.passportNumber || null,  
        userData.married,
        userData.militaryService,
        userData.pensionsEstablished || null,  
        userData.additionalDescription || null, 
        userData.bloodType || null, 
        userData.driversLicenseType || null, 
        userData.driversCertificateNumber || null,  
        userData.disabled,
        userData.isActive || true,  
        userData.email
      ];
      
      console.log(userQuery);
      console.log(userValues);
      const insertResult = await client.query(userQuery, userValues);

      const user = await client.query('SELECT user_id FROM auth_user WHERE login_name = $1', [loginName]);
      const userToTeacher = user.rows[0];

      const userSignature = {
        userId: insertResult.rows[0].user_id,
        userRegistryNumber: insertResult.rows[0].registry_number,
        userRole: insertResult.rows[0].user_role,
        signature: signature,  
      };

      const signatureQuery = `
      INSERT INTO public.user_signatures (
        user_id, user_registry_number, user_role, signature
      ) 
      VALUES (
        $1, $2, $3, $4
      ) RETURNING user_signature_id, user_registry_number;
      `;
      
      const signatureValues = [
        userSignature.userId,
        userSignature.userRegistryNumber,
        userSignature.userRole,
        userSignature.signature
      ];
      const insertResultSignature = await client.query(signatureQuery, signatureValues);
      console.log(insertResultSignature.rows[0].user_registry_number);


      const teacher_email = loginName + '.teacher@studentsystem.mn';
      console.log(userToTeacher, teacher_email);

      const teacherData = {
        user_id: userToTeacher.user_id,
        teacher_code: loginName,
        teacher_email: teacher_email,
        certificate: null,
        profession: profession,
        academic_degree: selectedAcademicDegree,
        job_post: jobPost,
        departmenst_of_education_id: branch_school_id,
        department_id: departments,
        };


        try {
          const teacherQuery = `
            INSERT INTO public.teacher (
              user_id,
              teacher_code,
              teacher_email,
              certificate,
              profession,
              academic_degree,
              job_title,
              departments_of_education_id,
              department_id
            )
            VALUES (
              $1, $2, $3, $4, $5, $6, $7, $8, $9
            )
            RETURNING teacher_id, user_id;
          `;
      
          const teacherValues = [
            teacherData.user_id,
            teacherData.teacher_code,
            teacherData.teacher_email,
            teacherData.certificate,
            teacherData.profession,
            teacherData.academic_degree, 
            teacherData.job_post,
            teacherData.departmenst_of_education_id,
            teacherData.department_id,
          ];
      
          const result = await client.query(teacherQuery, teacherValues);
          const user_id = result.rows[0].user_id.toString(); // Ensure user_id is a string
          console.log('Багш teacher_id:', result.rows[0].teacher_id);

          const add_teacher_to_ed_department = await client.query(
            `UPDATE departmentsofeducation 
            SET teachers = COALESCE(teachers, jsonb_build_object('user_id', 'init', 'teacher_name', 'init')) || 
                jsonb_build_object('user_id', $2::text, 'teacher_name', $3::text)
            WHERE departments_of_education_id = $1`, 
            [branch_school_id, user_id, String(userValues[5])]
          );

          console.log(add_teacher_to_ed_department.rowCount);
          const add_teacher_to_department = await client.query(
            `UPDATE department
            SET number_of_staff = COALESCE(number_of_staff, 0) + $1 
            WHERE department_id = $2`, [1, departments]
          );

        }catch (error) {
          console.error(error);
          return res.status(500).json({
            message: 'Internal Server Error'
          });
        }

      return res.status(200).json({
        message: 'Хэрэглэгчийн бүртгэлийг үүсгэлээ!',
        user: (insertResult.rows[0].user_id, insertResult.rows[0].loginName, registryNumber.slice(2))
      });
  
    } else {
     
      return res.status(400).json({
        message: 'Энэ хэрэглэгч аль хэдийн бүртгэгдсэн байна.'
      });
    }
  
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Internal Server Error'
    });
  }
});



// Login Route
app.post('/login', async (req, res) => {
  const { login_name, password_hash } = req.body;

  const salt = await bcrypt.genSalt(10);
  let password_hash_test = await bcrypt.hash(password_hash, salt);

  try {
    const result = await client.query('SELECT user_id, password_hash, user_role FROM auth_user WHERE login_name = $1', [login_name]);
   
    if (result.rows.length === 0) {
      return res.status(401).json({ message: 'Буруу нэр эсвэл нууц үг байна!' });
    }

    const user = result.rows[0];
    const isPasswordValid = await bcrypt.compare(password_hash, user.password_hash);


    if (isPasswordValid) {
      return res.status(200).json({ message: 'Амжилттай нэвтэрлээ', user });
    } else {
      return res.status(401).json({ message: 'Буруу нэр эсвэл нууц үг байна' });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});


// Get user data of Student
app.post('/User/Login/Student', async (req, res) => {
  const { user_id } = req.body;
  console.log("Received user_id:", user_id);

  if (!user_id) {
    return res.status(400).json({ message: 'User ID is required' });
  }

  try {
    const user_query = await client.query('SELECT * FROM auth_user WHERE user_id = $1', [user_id]);
    const student_query = await client.query('SELECT * FROM student WHERE user_id = $1', [user_id]);

    const user = user_query.rows[0];
    const student = student_query.rows[0];

    const department_query = await client.query('SELECT * FROM department WHERE department_id = $1', [student.department_id]);
    const department = department_query.rows[0];

    const major_query = await client.query('SELECT * FROM major WHERE major_id = $1', [student.major_id]);
    const major = major_query.rows[0];
    if (user) {
      console.log('User found:', user);
      return res.status(200).json({ message: 'Амжилттай нэвтэрлээ', student, user, major, department});
    } else {
      console.log('User not found');
      return res.status(401).json({ message: 'Алдаа гарлаа' });
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});



// Get user data of Teacher
app.post('/User/Login/Teacher', async (req, res) => {
  const { user_id } = req.body;
  console.log("/User/Login/Teacher Received user_id:", user_id);

  if (!user_id) {
    return res.status(400).json({ message: 'User ID is required' });
  }

  try {
    const user_query = await client.query('SELECT * FROM auth_user WHERE user_id = $1', [user_id]);
    const teacher_query = await client.query('SELECT * FROM teacher WHERE user_id = $1', [user_id]);

    const user = user_query.rows[0];
    const teacher = teacher_query.rows[0];

    const department = await client.query('SELECT * FROM department WHERE department_id = $1', [teacher.department_id]);
    const dep = department.rows[0];

    const department_of_edu = await client.query('SELECT * FROM departmentsofeducation WHERE departments_of_education_id = $1', [teacher.departments_of_education_id]);
    const dept_of_edu = department_of_edu.rows[0];

    const teachers_selected_majors = await client.query(`
      SELECT * FROM teachersmajorplanning WHERE teacher_id = $1`, [teacher.teacher_id]);
    const teachers_major = teachers_selected_majors.rows;

    const teachers_selected_majors_courses = await client.query(`
      SELECT * FROM teacherscourseplanning 
      WHERE teacher_id = $1`, [teacher.teacher_id]);
    
    const selected_major_courses = teachers_selected_majors_courses.rows;

    if (user) {;
      return res.status(200).json({ message: 'Амжилттай нэвтэрлээ', teacher, user, dep, dept_of_edu, teachers_major, selected_major_courses});
    } else {
      console.log('User not found');
      return res.status(401).json({ message: 'Алдаа гарлаа' });
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});



// Get all Major of Departmens Of Education
app.post('/Get/allMajor/Of/DepartmentsOfEducation', async (req, res) => {
  const { departments_of_edu_id, teacher_id, department_id } = req.body;
  if (departments_of_edu_id === undefined && teacher_id === undefined) {
    console.log('null condition of departments_of_edu_id and teacher_id');
  
    try {
      const department_query = await client.query(`
        SELECT * FROM department WHERE department_id = $1`, [department_id]);
    
      const department = department_query.rows[0];
      
      if (department !== undefined) {
      return res.status(200).json({ message: 'Багшийн холбогдох салбар сургуулийг татлаа', department });
      } else {
        console.log('Department not found');
        return res.status(401).json({ message: 'Алдаа гарлаа' });
      }
    } catch (error) {
      console.error('Database query failed:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  } else if (department_id === undefined) {
    console.log('null condition of department_id');
    try {
      const dep_of_edu_id = await client.query(
        'SELECT ' +
        'departmentsofeducation.departments_of_education_id, departmentsofeducation.ed_department_name '+
        'FROM departmentsofeducation '+
        'JOIN teacher '+
        'ON teacher.departments_of_education_id = departmentsofeducation.departments_of_education_id '+
        'WHERE teacher.departments_of_education_id = $1', [departments_of_edu_id]);
      const dep_of_edus_courses = await client.query('SELECT * FROM major WHERE department_of_edu_id = $1', [dep_of_edu_id.rows[0].departments_of_education_id]);
      const teachers_major_selections = await client.query(`
        SELECT * FROM teachersmajorplanning WHERE teacher_id = $1`, [teacher_id]);

      courses = dep_of_edus_courses.rows;
      if (courses.length > 0) {
        return res.status(200).json({ message: 'Хөтөлбөрүүдийг амжилттай татлаа', courses, teachers_major_selections});
      } else {
        console.log('Majors not found');
        return res.status(401).json({ message: 'Алдаа гарлаа' });
      }
    } catch (error) {
      console.error('Database query failed:', error);
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }
});

// Get all previously selected majors of Teacher for ui ux 
app.get('/Get/Current/MajorsPlanning/Of/Teacher', async (req, res) => {
  const { teacher_id } = req.query;  
  console.log('Received Teacher Id of:', teacher_id);

  try {
    const selected_majors_of_teacher = await client.query(
      `SELECT * FROM teachersmajorplanning WHERE teacher_id = $1`, [teacher_id]
    );

    console.log(selected_majors_of_teacher.rows.length);
    const selected_majors = selected_majors_of_teacher.rows;
    if (selected_majors.length > 0) {
      console.log('Teacher has majors selected', selected_majors);
      return res.status(200).json({
        message: 'Багшийн аль хэдийн сонгосон хөтөлбөрүүд',
        selected_majors
      });
    } else {
      console.log('Teacher has no selected majors');
      return res.status(404).json({
        message: 'Teacher has no selected majors'
      });
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});



// Get all current Teachers Majors
app.post('/Get/Current/Majors/Of/Teacher', async (req, res) => {
  const { teacher_id, major_id } = req.body;
  console.log("/Get/Current/Majors/Of/Teacher Received Teacher Id of:", teacher_id, "Major Id of:", major_id);
  var dupli_major_count;
  try {
    const duplicate_majors_entry_check =
    await client.query(`
      SELECT COUNT(*), major_name FROM teachersmajorplanning WHERE teacher_id = $1 AND major_id = $2
      GROUP BY major_name`, [teacher_id, major_id]);

      if (duplicate_majors_entry_check.rows[0] === undefined) {
        dupli_major_count = { count: '0', major_name: 'Програм Хангамж' }
      } else {
        dupli_major_count = parseInt(duplicate_majors_entry_check.rows[0].count);
      }

    if (dupli_major_count === 1) {
      return res.status(202).json({ message: `
        Багшид ${duplicate_majors_entry_check.rows[0].major_name}
        хөтөлбөр аль хэдийн оноогдсон байна`})
    } else {
      
      const current_majors_teacher = await client.query(
        'SELECT * FROM teachersmajorplanning WHERE teacher_id = $1', [teacher_id]);

      const add_to_teacher_major = await client.query(
        'SELECT * FROM major WHERE major_id = $1', [major_id]);

      teachers_majors_count = current_majors_teacher.rows.length;
      current_majors = current_majors_teacher.rows;
      a_major_to_be_added = add_to_teacher_major.rows[0];
      if (teachers_majors_count > 0) {
        console.log('Majors found for Teacher Id of:', teacher_id);
        return res.status(200).json({ message: 'Багшийн сонгосон хөтөлбөрүүдийг амжилттай татлаа', current_majors, a_major_to_be_added});
      } else {
        console.log('Majors not found');
        return res.status(201).json({ message: 'Багшийн нэр дээр сонгосон хөтөлбөр байхгүй байна', a_major_to_be_added});
      }
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});

// Add Major to Teacher
app.post('/Add/Major/To/Teacher', async (req, res) => {
  const { 
    teacher_id,
    academic_degree_of_major,
    major_name,
    major_id,
    credit,
    department_id,
    created_at,
    department_of_educations_id
  } = req.body;

  console.log("Received A Major of:", major_id, "to be added");

  try {
    const majorToAddQuery = `
      INSERT INTO public.teachersmajorplanning (
        teacher_id, academic_degree_of_major, major_name, major_id, credit, department_id, created_at, 
        department_of_educations_id
      ) 
      VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8
      ) RETURNING teacher_id, major_name, major_id;
    `;

    const majorToBeAddedValues = [
      teacher_id,
      academic_degree_of_major,
      major_name,
      major_id,
      credit,
      department_id,
      created_at,
      department_of_educations_id
    ];

    console.log("Хадгалах өгөгдөл:", majorToBeAddedValues);
  
    const insertResult = await client.query(majorToAddQuery, majorToBeAddedValues);

    if (insertResult.rows.length > 0) {
      const { teacher_id, major_name, major_id } = insertResult.rows[0];


      return res.status(200).json({
        message: 'Багшийн нээр дээр хөтөлбөрийн мэдээллийг хадгаллаа.',
        user: {
          teacher_id,        
          major_name,        
          major_id,          
        }
      });
    } else {
      return res.status(400).json({
        message: 'Мажор нэмэгдсэнгүй. Алдаа гарлаа!'
      });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Internal Server Error'
    });
  }
});

//Remove Major From Teacher
app.post('/Remove/Major/From/Teacher', async (req, res) => {
  const { 
    teacher_id,
    major_id
  } = req.body;

  console.log("Received A Teacher Id of:", teacher_id + " to remove Major Id of:", major_id);

  try {
    const majorToRemoveQuery = `
      DELETE FROM teachersmajorplanning WHERE teacher_id = $1 AND major_id = $2
      RETURNING teacher_id, major_name, major_id;
    `;

    const deleteResult = await client.query(majorToRemoveQuery, [teacher_id, major_id]);

    if (deleteResult.rows.length > 0) {
      const { teacher_id, major_name, major_id } = deleteResult.rows[0];

      return res.status(200).json({
        message: 'Хөтөлбөр амжилттай хасагдлаа!',
        deleted_major: {
          teacher_id,        
          major_name,        
          major_id,          
        }
      });
    } else {
      return res.status(404).json({
        message: 'Мажор олдсонгүй. Багшийн мэдээлэл байхгүй байна!'
      });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Internal Server Error'
    });
  }
});


// Get ALL majors data of teacher
app.post('/Get/allMajors/Of/Teacher', async (req, res) => {
  const { teacher_id } = req.body;
  console.log("Received Teacher Id of:", teacher_id);

  if (!teacher_id) {
    return res.status(400).json({ message: 'Teacher ID is required' });
  }

  try {
    const teachers_major_query = await client.query(
      `SELECT * FROM teachersmajorplanning WHERE teacher_id = $1`, [teacher_id]);
    teachers_majors = teachers_major_query.rows;
    let teacherCourses = [];

    if (teachers_majors.length > 0) {
      console.log('Majors found for Teacher Id of:', teacher_id);
      
      for (let i = 0; i < teachers_majors.length; i++) {
        console.log(teachers_majors[i]);
        try{
          const teachers_majors_courses_query = await client.query(`
            SELECT * FROM courses WHERE major_id = $1 ORDER BY course_year`, 
            [teachers_majors[i].major_id]
          );
          
          teacherCourses.push(...teachers_majors_courses_query.rows);
          
        }catch (error) {                                              
          console.error('Database query failed:', error);
          return res.status(500).json({ message: 'Internal Server Error' });
        }
      }
      console.log('Majors found for Teacher Id of:', teacherCourses);
      return res.status(200).json({ message: 'Багшийн хөтөлбөрийн хичээлүүдийг амжилттай авлаа', teacherCourses });
      
    } else {
      console.log('User not found');
      return res.status(401).json({ message: 'Багшид хөтөлбөрийн мэдээлэл байхгүй байна!' });
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});


app.post('/Get/AllCourses/Of/Teachers/Selected/Major', async (req, res) => {
  const { course_code, selected_majors } = req.body;
  console.log('/Get/AllCourses/Of/Teachers/Selected/Major Received course code of :', course_code);
  console.log('/Get/AllCourses/Of/Teachers/Selected/Major Received Teachers selected majors of:', selected_majors.length);

  let courses = new Set(); 
  
  try {
    let teachers_courses = [];
    for (let i = 0; i < selected_majors.length; i++) {
      const courses_of_teachers_selected_majors = await client.query(
        `SELECT * FROM courses WHERE major_id = $1 AND course_code LIKE $2 ORDER BY course_year`, 
        [selected_majors[i].major_id, `${course_code}%`] 
      );

      courses_of_teachers_selected_majors.rows.forEach(row => {
        courses.add(row);  
      });
    }
    console.log(courses);
    teachers_courses = Array.from(courses);

    if (teachers_courses.length > 0) {
      console.log('Багшид оноогдсон хөтөлбөрийн хичээлүүдийг татлаа.');
      return res.status(200).json({ message: 'Багшийн хичээлүүдийг татлаа', teachers_courses });
    } else {
      console.log('Багшид оноогдсон хөтөлбөрт хичээл байхгүй байна.');
      return res.status(404).json({ message: 'Багшийн хөтөлбөрт хичээл байхгүй байна' });
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});



app.get('/Get/Current/CoursesPlanning/Of/Teacher', async (req, res) => {
  const { teacher_id } = req.query;
  console.log('/Get/Current/CoursesPlanning/Of/Teacher Recieved Teacher Id: for CoursesPlanning', teacher_id);

  try {

    /* 
    const duplicate_courses_entry_check =
    await client.query(`
      SELECT COUNT(*), major_name FROM teachersmajorplanning WHERE teacher_id = $1 AND major_id = $2
      GROUP BY major_name`, [teacher_id, major_id]);

      if (duplicate_courses_entry_check.rows[0] === undefined) {
        dupli_courses_count = { count: '0', major_name: 'Програм Хангамж' }
      } else {
        dupli_courses_count = parseInt(duplicate_courses_entry_check.rows[0].count);
      }

    if (dupli_courses_count === 1) {
      return res.status(202).json({ message: `
        Багшид ${duplicate_courses_entry_check.rows[0].major_name}
        хөтөлбөр аль хэдийн оноогдсон байна`})
    } else {
    */

      const current_courses_teacher = await client.query(`
        SELECT * FROM teacherscourseplanning WHERE teacher_id = $1`, [teacher_id]);
      const current_courses = current_courses_teacher.rows;
      console.log(current_courses.length);

      if (current_courses.length > 0){
        console.log('Багшид хичээлүүд байна.');
        return res.status(200).json({ message: 'Багшийн хичээлүүд', current_courses });
      } else if (current_courses.length === 0) {
        console.log('Багшид одоогоор хичээл байхгүй байна');
        return res.status(200).json({ message: 'Багш хичээлгүй байна', current_courses });
      } else {
        return res.status(404).json({ message: 'Багш хичээлгүй байна' });
      }
    
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }

});


// add course to teacher
app.post('/Add/Courses/OfMajor/To/Teacher', async (req, res) => {
  const { teacher, course, selectedMajor } = req.body;
  console.log("/Add/Courses/OfMajor/To/Teacher Received Teacher Id of:", teacher.teacher_id, "Course Id of:", course.course_id, "Major Id of:", selectedMajor.major_id);
  try {

      const courseToAddQuery = `
        INSERT INTO public.teacherscourseplanning (teacher_id, major_name, major_id, course_name, credit, course_id,
        department_id, department_of_edu_id, course_code, teacher_major_id) 
        VALUES (
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
        ) RETURNING teacher_course_planning_id, course_name, major_name;`;

      const courseToBeAddedValues = [
        teacher.teacher_id,
        selectedMajor.major_name,
        selectedMajor.major_id,
        course.course_name,
        course.total_credits,
        course.course_id,
        teacher.department_id,
        teacher.departments_of_education_id,
        course.course_code,
        selectedMajor.teacher_major_id
      ];

      const insertResult = await client.query(courseToAddQuery, courseToBeAddedValues);
      
      if (insertResult.rows.length > 0) {
        const { teacher_course_planning_id, course_name, major_name } = insertResult.rows[0];

        return res.status(200).json({
          message: 'Хичээл амжилттай нэмэгдлээ!',
          teachers_course_planning: {
            teacher_course_planning_id,
            course_name,
            major_name
          }
        });
      } else {
        return res.status(400).json({ message: 'Хичээл нэмэхэд алдаа гарлаа! Дахин оролдоно уу!' });
      }   
    
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});


//Remove Course From Teacher
app.delete('/Remove/Course/From/Teacher', async (req, res) => {
  const { teacher_id, course } = req.body;
  
  console.log('/Remove/Course/From/Teacher Received Teacher Id of:', teacher_id, 
              'to remove Course Id of:', course.course_id, 'Major Id of:', course.major_id);
  try {
      
      const courseToRemoveQuery = await client.query(`
          DELETE FROM teacherscourseplanning 
          WHERE teacher_id = $1 AND course_id = $2
          AND major_id = $3
          RETURNING *`, 
          [teacher_id, course.course_id, course.major_id]
      );

      if (courseToRemoveQuery.rowCount === 0) {
          return res.status(404).json({
              success: false,
              message: 'No matching teacher-course assignment found'
          });
      } else {

        res.status(200).json({
            success: true,
            message: `хичээлийг амжилттай хаслаа!`,
            deletedCount: courseToRemoveQuery.rowCount
        });
    }
  } catch (error) {
      console.error('Error removing course from teacher:', error);
      res.status(500).json({
          success: false,
          message: 'Internal server error while removing course',
          error: error.message
      });
  }
});

// Get user data
app.post('/Get/Student/Major/Courses/', async (req, res) => {
  const { major_id } = req.body;

  console.log("Received major_id:", major_id);

  try {
    const courses = await client.query('SELECT * FROM courses WHERE major_id = $1 ORDER BY course_year, course_type', [major_id]);
    if (courses.rows.length === 0) {
      console.log('Majors courses not found');
      return res.status(401).json({ message: 'Алдаа гарлаа' });
    } else {
      const majors_courses = courses.rows;
      for (let i = 0; i < majors_courses.length; i++) {
        if (majors_courses['course_year'] === '1-р курс'){
          console.log(majors_courses);
        }
      }
      
      console.log(majors_courses.length);
      return res.status(200).json({ message: 'Хөтөлбөрийн хичээлүүдийг амжилттай авлаа', majors_courses });
    }
  } catch (error) {
    console.error('Database query failed:', error);
    return res.status(500).json({ message: 'Internal Server Error' });
  }
});


// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
