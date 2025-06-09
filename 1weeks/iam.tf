# 1. IAM 사용자 생성
resource "aws_iam_user" "student2" {
  name = "Student2"
}

# 2. 사용자에게 AdministratorAccess 정책을 연결
resource "aws_iam_user_policy_attachment" "student2_admin" {
  user       = aws_iam_user.student2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 3. 콘솔 로그인용 비밀번호 생성
resource "aws_iam_user_login_profile" "student2_console_access" {
  user                    = aws_iam_user.student2.name
  password_reset_required = true
  password                = "raon123!" # 초기 비밀번호 
}

