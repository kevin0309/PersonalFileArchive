CREATE TABLE `member_tier` (
  `code` varchar(20) NOT NULL COMMENT '회원 등급 코드',
  `name` varchar(20) NOT NULL COMMENT '회원 등급 이름',
  `order_priority` int(11) NOT NULL COMMENT '상위 노출 우선 순위',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='회원 등급';


CREATE TABLE `member` (
  `id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '회원 아이디',
  `name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '회원 성함',
  `nickname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '회원 닉네임',
  `email_address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '회원 이메',
  `birth` date NOT NULL DEFAULT '0000-00-00' COMMENT '회원 생년월일',
  `sex` varchar(11) NOT NULL,
  `profile_picture` varchar(20) DEFAULT NULL COMMENT '회원 프로필 사진',
  `introduce` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '한 줄 소개',
  `auth_code` varchar(20) NOT NULL COMMENT '회원 등급코드',
  `is_valid` int(11) DEFAULT '1' COMMENT '사용가능 상태인지(0 or 1)',
  `is_resign` int(11) DEFAULT '0' COMMENT '회원 탈퇴 여부(0 or1)',
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일자',
  PRIMARY KEY (`id`),
  KEY `member_auth` (`auth_code`),
  CONSTRAINT `member_auth` FOREIGN KEY (`auth_code`) REFERENCES `member_tier` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='회원 테이블';

CREATE TABLE `member_password` (
  `seq` int(11) NOT NULL AUTO_INCREMENT COMMENT '순차 인덱스',
  `member_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '유저 아이디',
  `member_password` varchar(50) NOT NULL COMMENT '유저 패스워드',
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '유저가 비밀번호를 지정한 날짜 (가장 최신 날짜)',
  PRIMARY KEY (`seq`),
  KEY `member_id_client_password_change_log` (`member_id`),
  CONSTRAINT `member_id_client_password` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='회원 비밀번호 지정 내역';

CREATE TABLE `member_login_log` (
  `seq` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Row가 늘어날 때 마다 순차적으로 늘어나는 인덱스',
  `member_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '유저 ID',
  `tried_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '유저가 접근한 시간',
  `browser_info` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '''unknown''' COMMENT '접근한 클라이언트의 브라우저 정보',
  `req_ip` varchar(20) NOT NULL COMMENT '접근한 클라이언트의 IP',
  `is_success` int(11) NOT NULL COMMENT '로그인 성공 여부',
  PRIMARY KEY (`seq`),
  KEY `member_id_member_login_log` (`member_id`),
  CONSTRAINT `member_id_member_login_log` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='회원 로그인 시도 로그';

CREATE TABLE `member_activity_type` (
  `code` varchar(20) NOT NULL COMMENT '활동 코드',
  `name` varchar(20) NOT NULL COMMENT '활동의 이름',
  `order_priority` int(11) NOT NULL COMMENT '상위 노출 우선 순위',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='활동 내역 종류';

CREATE TABLE `member_activity_log` (
  `seq` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Row가 늘어날 때 마다 순차적으로 늘어나는 인덱스',
  `member_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '유저 ID',
  `activity_code` varchar(20) NOT NULL COMMENT '활동 내역 종류 코드',
  `activity_content` varchar(20) DEFAULT NULL COMMENT '유저의 실제 활동 내역 이름',
  `is_open` int(11) NOT NULL COMMENT '공개 여부(0,1,2 :: 0 - 나만보기, 1- 팔로워에게만 공개, 2-전체 공개)',
  PRIMARY KEY (`seq`),
  KEY `member_id_activity_log` (`member_id`),
  KEY `activity_code` (`activity_code`),
  CONSTRAINT `activity_code` FOREIGN KEY (`activity_code`) REFERENCES `member_activity_type` (`code`),
  CONSTRAINT `member_id_activity_log` FOREIGN KEY (`member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='회원 활동 내역';

CREATE TABLE `banned_string` (
  `content` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '금지된 문자열 내용 regexp를 따름',
  PRIMARY KEY (`content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='회원 지정 불가능 ID, 닉네임';

CREATE TABLE `server_log_stack` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `year` varchar(11) NOT NULL,
  `month` varchar(11) NOT NULL,
  `date` varchar(11) NOT NULL,
  `hour` varchar(11) NOT NULL,
  `min` varchar(11) NOT NULL,
  `duration` int(11) NOT NULL,
  `regdate` date NOT NULL,
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `file_category` (
  `code` varchar(20) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `order_priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='파일 종류';

CREATE TABLE `file_board_list` (
  `board_id` varchar(30) NOT NULL,
  `board_name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `is_private` int(11) NOT NULL DEFAULT '0',
  `is_deleted` int(11) NOT NULL DEFAULT '0',
  `pwd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `owner_member_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`board_id`),
  KEY `board_mem_id` (`owner_member_id`),
  CONSTRAINT `board_mem_id` FOREIGN KEY (`owner_member_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `uploaded_file` (
  `board_id` varchar(30) NOT NULL,
  `file_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `original_file_name` varchar(200) DEFAULT NULL,
  `original_file_ext` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `file_category` varchar(50) DEFAULT NULL,
  `upload_member_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_del` int(11) NOT NULL DEFAULT '0',
  `request_ip` varchar(20) DEFAULT NULL,
  `regdate` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`file_id`),
  KEY `boardid` (`board_id`),
  CONSTRAINT `boardid` FOREIGN KEY (`board_id`) REFERENCES `file_board_list` (`board_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='업로드된 파일';

CREATE TABLE `encoding_preset` (
  `code` varchar(20) NOT NULL COMMENT '프리셋 코드 (영어)',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '프리셋 이름 (한글)',
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='인코딩 옵션 프리셋목록';

CREATE TABLE `encoding_preset_option` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `preset_code` varchar(20) NOT NULL COMMENT '프리셋 ID',
  `option_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '인코딩 옵션명',
  `option_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '인코딩 옵션값',
  `orderby` int(11) NOT NULL,
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  KEY `encoding_preset_option-encoding_preset` (`preset_code`),
  CONSTRAINT `encoding_preset_option-encoding_preset` FOREIGN KEY (`preset_code`) REFERENCES `encoding_preset` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='인코딩 프리셋 옵션목록';

CREATE TABLE `encoding_queue` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '원본 파일 ID',
  `preset_code` varchar(20) NOT NULL COMMENT '인코딩 옵션 프리셋',
  `status` varchar(20) NOT NULL COMMENT '인코딩 상태 (waiting : 대기중 / running : 진행중 / finished : 완료 / error : 알 수 없는 에러)',
  `s_date` timestamp NULL DEFAULT NULL COMMENT '인코딩 시작시간',
  `e_date` timestamp NULL DEFAULT NULL COMMENT '인코딩 완료시간',
  `new_directory` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '인코딩 파일 저장 디렉토리 (서버 어플리케이션에 로드된 HDD 디렉토리에서의 상대경로로 표시, ex: 1://video/720p/~~~.mp4)',
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`seq`),
  KEY `encoding_queue-encoding_preset` (`preset_code`),
  KEY `encoding_queue-video` (`file_id`),
  CONSTRAINT `encoding_queue-encoding_preset` FOREIGN KEY (`preset_code`) REFERENCES `encoding_preset` (`code`),
  CONSTRAINT `encoding_queue-video` FOREIGN KEY (`file_id`) REFERENCES `uploaded_file` (`file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='인코딩 대기열 목록';

CREATE TABLE `file_division` (
  `division_code` varchar(20) NOT NULL,
  `category_code` varchar(20) DEFAULT NULL,
  `division_name` varchar(20) DEFAULT NULL,
  `division_description` varchar(200) DEFAULT NULL,
  `order_priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`division_code`),
  KEY `file_category` (`category_code`),
  CONSTRAINT `file_category` FOREIGN KEY (`category_code`) REFERENCES `file_category` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='저장된 파일 구분';

CREATE TABLE `uploaded_file_server_stored_directory` (
  `seq` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `file_ext` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `division_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `volume` bigint(20) DEFAULT NULL,
  `volume_str` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `server_directory` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `dir_fileID` (`file_id`,`division_code`),
  KEY `division` (`division_code`),
  CONSTRAINT `division` FOREIGN KEY (`division_code`) REFERENCES `file_division` (`division_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
