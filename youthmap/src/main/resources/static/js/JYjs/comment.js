document.addEventListener("DOMContentLoaded", function () {
    const boardNo = document.getElementById("boardNo").value;
    const commentList = document.getElementById("commentList");
    const commentInput = document.getElementById("commentInput");
    const commentForm = document.getElementById("commentForm");

    // ✅ 로그인 상태 확인 함수
    function isLoggedIn() {
        return loginUserId && loginUserId !== 'null' && loginUserId !== '';
    }

    // ✅ 1. 댓글 목록 불러오기
    function loadComments() {
        fetch(`/api/comments/${boardNo}`)
            .then(res => res.json())
            .then(data => {
                commentList.innerHTML = ""; // 기존 댓글 제거
                
                if (data.length === 0) {
                    commentList.innerHTML = "<p class='error-message'>아직 댓글이 없습니다.</p>";
                    return;
                }
                
                data.forEach(c => {
                    const item = document.createElement("li");
                    item.className = "comment-item";

                    // 수정/삭제 버튼
                    let actions = "";
                    if (isLoggedIn() && (loginUserId === c.memId || loginUserRole === 'ADMIN')) {
                        const deleteClass = loginUserRole === 'ADMIN' ? 'admin-delete' : '';
                        actions = `
                            <div class="comment-actions">
                                ${loginUserId === c.memId ? '<a href="javascript:void(0);" onclick="editComment(' + c.commNo + ')">수정</a>' : ''}
                                <a href="javascript:void(0);" onclick="deleteComment(${c.commNo})" class="${deleteClass}">삭제</a>
                            </div>
                        `;
                    }

                    item.innerHTML = `
                        <div class="comment-avatar">
                            <img src="/img/JYimg/Profile_icon.png" alt="프로필">
                        </div>
                        <div class="comment-body">
                            <div class="comment-author-line">
                                <span class="comment-author">${c.memName}</span>
                                <span class="comment-text">${c.commContent}</span>
                            </div>
                            <div class="comment-info">
                                <span class="comment-time">${formatDate(c.commDate)}</span>
                                ${actions}
                            </div>
                        </div>
                    `;
                    commentList.appendChild(item);
                });
            })
            .catch(error => {
                console.error("댓글 목록 로드 실패:", error);
                commentList.innerHTML = "<p class='error-message'>댓글을 불러오는 중 오류가 발생했습니다.</p>";
            });
    }

    // ✅ 2. 댓글 등록
	console.log("로그인한 사용자 ID:", loginUserId);  // ✅ 이제 오류 안 남

	commentForm.addEventListener("submit", function (e) {
	    e.preventDefault();

	    const content = commentInput.value.trim();

	    if (!isLoggedIn()) {
	        alert("로그인 후 댓글 작성이 가능합니다.");
	        return;
	    }

	    if (!content) {
	        alert("댓글을 입력하세요!");
	        return;
	    }

	    // 로딩 상태 표시
	    const submitBtn = commentForm.querySelector('button[type="submit"]');
	    const originalText = submitBtn.textContent;
	    submitBtn.textContent = "등록 중...";
	    submitBtn.disabled = true;

	    fetch("/api/comments", {
	        method: "POST",
	        headers: { "Content-Type": "application/json" },
	        body: JSON.stringify({
	            boardNo: boardNo,
	            memId: loginUserId,
	            commContent: content
	        })
	    }).then(res => res.text())
	      .then(result => {
	          if (result === "success") {
	              commentInput.value = "";
	              loadComments();
	          } else {
	              alert("댓글 등록 실패");
	          }
	      })
	      .catch(error => {
	          console.error("댓글 등록 실패:", error);
	          alert("댓글 등록 중 오류가 발생했습니다.");
	      })
	      .finally(() => {
	          // 로딩 상태 해제
	          submitBtn.textContent = originalText;
	          submitBtn.disabled = false;
	      });
	});

    // ✅ 3. 댓글 삭제
    window.deleteComment = function (commNo) {
        if (!confirm("댓글을 삭제하시겠습니까?")) return;

        fetch(`/api/comments/${commNo}`, {
            method: "DELETE",
			credentials: "include"  // ✅ 세션 쿠키 포함!
        })
        .then(res => res.text())
        .then(result => {
            if (result === "success") {
                loadComments();
            } else {
                alert("삭제 실패");
            }
        })
        .catch(error => {
            console.error("댓글 삭제 실패:", error);
            alert("댓글 삭제 중 오류가 발생했습니다.");
        });
    };

    // ✅ 날짜 포맷
    function formatDate(dateStr) {
        const d = new Date(dateStr);
        const hours = d.getHours();
        const minutes = d.getMinutes().toString().padStart(2, '0');
        return `${d.getFullYear()}.${d.getMonth() + 1}.${d.getDate()} (${hours >= 12 ? 'PM' : 'AM'}) ${hours % 12 || 12}:${minutes}`;
    }

    // ✅ 첫 댓글 목록 로딩
    loadComments();
});