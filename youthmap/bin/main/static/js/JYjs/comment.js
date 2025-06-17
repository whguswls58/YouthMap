document.addEventListener("DOMContentLoaded", function () {
    const boardNo = document.getElementById("boardNo").value;
    const commentList = document.getElementById("commentList");
    const commentInput = document.getElementById("commentInput");
    const commentForm = document.getElementById("commentForm");

    // ✅ 1. 댓글 목록 불러오기
    function loadComments() {
        fetch(`/api/comments/${boardNo}`)
            .then(res => res.json())
            .then(data => {
                commentList.innerHTML = ""; // 기존 댓글 제거
                data.forEach(c => {
                    const item = document.createElement("div");

                    // 본인 댓글이면 삭제 버튼 생성
                    let deleteBtn = "";
					if (loginUserId && (loginUserId === c.memId || loginUserRole === 'ADMIN')) {
					    deleteBtn = `<button onclick="deleteComment(${c.commNo})">삭제</button>`;
					}

                    item.innerHTML = `
                        <b>${c.memId}</b> (${formatDate(c.commDate)}):<br/>
                        ${c.commContent}<br/>
                        ${deleteBtn}
                        <hr/>
                    `;
                    commentList.appendChild(item);
                });
            });
    }

    // ✅ 2. 댓글 등록
	console.log("로그인한 사용자 ID:", loginUserId);  // ✅ 이제 오류 안 남

	commentForm.addEventListener("submit", function (e) {
	    e.preventDefault();

	    const content = commentInput.value.trim();

	    if (!loginUserId) {
	        alert("로그인 후 댓글 작성이 가능합니다.");
	        return;
	    }

	    if (!content) {
	        alert("댓글을 입력하세요!");
	        return;
	    }

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