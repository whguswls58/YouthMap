document.addEventListener("DOMContentLoaded", function () {
    const resId = document.getElementById("resId").value;
    const reviewList = document.getElementById("reviewList");
    const reviewInput = document.getElementById("reviewInput");
    const reviewForm = document.getElementById("reviewForm");

    function isLoggedIn() {
        return loginUserId && loginUserId !== 'null' && loginUserId !== '';
    }

    // ✅ 후기 목록 불러오기
    function loadReviews() {
        fetch(`/api/reviews/${resId}`)
            .then(res => res.json())
            .then(data => {
                reviewList.innerHTML = "";

                if (data.length === 0) {
                    reviewList.innerHTML = "<p class='error-message'>아직 후기가 없습니다.</p>";
                    return;
                }

                data.forEach(r => {
                    const item = document.createElement("li");
                    item.className = "review-item";

                    let actions = "";
                    if (isLoggedIn() && (loginUserId === r.memId || loginUserRole === 'ADMIN')) {
                        const deleteClass = loginUserRole === 'ADMIN' ? 'admin-delete' : '';
                        actions = `
                            <div class="review-actions">
                                ${loginUserId === r.memId ? '<a href="javascript:void(0);" onclick="editReview(' + r.reviewId1 + ')">수정</a>' : ''}
                                <a href="javascript:void(0);" onclick="deleteReview(${r.reviewId1})" class="${deleteClass}">삭제</a>
                            </div>
                        `;
                    }

                    item.innerHTML = `
                        <div class="review-author-line">
                            <span class="review-author">${r.memName}</span>
                            <span class="review-date">${formatDate(r.reviewRegister1)}</span>
                        </div>
                        <div class="review-text">${r.reviewContent1}</div>
                        <div class="review-rating">별점: ${r.reviewScore1}</div>
                        ${r.reviewFile1 ? `<div class="review-image"><img src="/images/${r.reviewFile1}" style="max-width: 200px;"></div>` : ''}
                        ${actions}
                    `;

                    reviewList.appendChild(item);
                });
            })
            .catch(error => {
                console.error("후기 목록 로드 실패:", error);
                reviewList.innerHTML = "<p class='error-message'>후기를 불러오는 중 오류가 발생했습니다.</p>";
            });
    }

    // ✅ 후기 등록
    reviewForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const content = reviewInput.value.trim();
        if (!isLoggedIn()) {
            alert("로그인 후 후기 작성이 가능합니다.");
            return;
        }
        if (!content) {
            alert("후기를 입력하세요!");
            return;
        }

        const formData = new FormData(reviewForm);

        const submitBtn = reviewForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = "등록 중...";
        submitBtn.disabled = true;

        fetch("/reviewwrite", {
            method: "POST",
            body: formData
        })
        .then(res => res.text())
        .then(result => {
            if (result === "success") {
                reviewInput.value = "";
                loadReviews();
            } else {
                alert("후기 등록 실패");
            }
        })
        .catch(error => {
            console.error("후기 등록 실패:", error);
            alert("후기 등록 중 오류가 발생했습니다.");
        })
        .finally(() => {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        });
    });

    // ✅ 후기 삭제
    window.deleteReview = function (reviewId1) {
        if (!confirm("후기를 삭제하시겠습니까?")) return;

        fetch(`/reviewdelete?review_id1=${reviewId1}&res_id=${resId}`, {
            method: "DELETE",
            credentials: "include"
        })
        .then(res => res.text())
        .then(result => {
            if (result === "success") {
                loadReviews();
            } else {
                alert("삭제 실패");
            }
        })
        .catch(error => {
            console.error("후기 삭제 실패:", error);
            alert("후기 삭제 중 오류가 발생했습니다.");
        });
    };

    // ✅ 날짜 포맷
    function formatDate(dateStr) {
        const d = new Date(dateStr);
        const hours = d.getHours();
        const minutes = d.getMinutes().toString().padStart(2, '0');
        return `${d.getFullYear()}.${d.getMonth() + 1}.${d.getDate()} (${hours >= 12 ? 'PM' : 'AM'}) ${hours % 12 || 12}:${minutes}`;
    }

    loadReviews();
});
