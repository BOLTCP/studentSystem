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
  database: 'studentsystemdb',
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
  console.log("Received email of :", registryNumber); 
 
  return res.status(200).json({ message: 'Иргэний мэдээлэл!',
    user_json:
    {
      "user_name": "Болд",
      "user_sirname": "Баатар",
      "registry_number": "ЙР74020163",
      "email": "citizen1@.com",
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


app.post('/Student/Signup/Create/User', async (req, res) => {

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
        [dep_code + enrollmentYear.slice(2) + '%' ]
      );
      
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



// Login Route
app.post('/login', async (req, res) => {
  const { login_name, password_hash } = req.body;

  console.log("Received login_name:", login_name);
  console.log("Received password_hash:", password_hash);

  try {
    // Query user by login_name
    const result = await client.query('SELECT user_id, password_hash, user_role FROM auth_user WHERE login_name = $1', [login_name]);
   
    if (result.rows.length === 0) {
      return res.status(401).json({ message: 'Буруу нэр эсвэл нууц үг байна!' });
    }

    const user = result.rows[0];
    console.log(user);
    // Compare hashed password using bcrypt's compare method
    const isPasswordValid = await bcrypt.compare(password_hash, user.password_hash);

    console.log(user.password_hash);
    console.log(isPasswordValid);

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


// Get user data
app.post('/User/Login', async (req, res) => {
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
