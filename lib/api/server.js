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
      const major = result.rows;
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
app.post('/Student/Signup/Validating', async (req, res) => {
  let { email, password } = req.body;
  console.log("Received majorId of :", email); 
 
  return res.status(200).json({ message: 'Сурагчийн шалгалт!',
    exam_json:
    {
      "student_name": "Aриун",
      "student_sirname": "Болд",
      "registry_number": "УП03231413",
      "exam_code": "S12345",
      "email": "exampl1@.com",
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
          'department.department_code ' + 
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
        loginName = dep_code + enrollmentYear.slice(2) + 'd' + '00' + students_count;
        console.log(loginName);
      }else if (students_count < 100 && students_count > 9 ) {
        loginName = dep_code + enrollmentYear.slice(2) + 'd' + '0' + students_count;
        console.log(loginName);
      }else if (students_count < 1000 && students_count > 99 ) {
        loginName = dep_code + enrollmentYear.slice(2) + 'd' + students_count;
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
        professionCertification: '*'
      };

      const insertQuery = `
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
      ) RETURNING user_id, login_name, password_hash;
      `;
      

      const insertValues = [
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
      
      
      console.log(insertQuery);
      console.log(insertValues);
      
      console.log(loginName);

      
      const insertResult = await client.query(insertQuery, insertValues);
      
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
    const result = await client.query('SELECT * FROM auth_user WHERE login_name = $1', [login_name]);
   
    if (result.rows.length === 0) {
      return res.status(401).json({ message: 'Буруу нэр эсвэл нууц үг байна!' });
    }

    const user = result.rows[0];

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
app.get('/api/user', (req, res) => {
  // Assuming user_id = 1 for testing
  client.query('SELECT * FROM auth_user WHERE user_id = $1', [1], (err, result) => {
    if (err) {
      console.error('Error executing query', err.stack);
      return res.status(500).json({ error: 'Failed to fetch user data' });
    }
    // Send user data as JSON if found
    if (result.rows.length > 0) {
      return res.json(result.rows[0]);
    } else {
      return res.status(404).json({ error: 'User not found' });
    }
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
