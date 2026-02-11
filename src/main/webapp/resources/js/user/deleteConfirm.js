document.addEventListener('DOMContentLoaded', function () {
  var cancelBtn = document.getElementById('cancelBtn');
  var deleteForm = document.getElementById('deleteForm');

  if (cancelBtn) {
    cancelBtn.addEventListener('click', function () {
      // 메인 페이지로 이동 (경로 필요에 맞게 수정)
      window.location.href = '/summat/sm/main.jsp';
    });
  }

  if (deleteForm) {
    deleteForm.addEventListener('submit', function (e) {
      var pw = document.getElementById('password_hash').value.trim();
      if (pw.length === 0) {
        e.preventDefault();
        alert('비밀번호를 입력하세요.');
        return false;
      }
      if (!confirm('정말로 탈퇴하시겠습니까? 탈퇴 시 계정 정보가 삭제됩니다.')) {
        e.preventDefault();
        return false;
      }
      // 제출 허용
    });
  }
});