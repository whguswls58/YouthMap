
// D-Day 출력
function getDday(dateStr) {

	if (!dateStr) return "";

	const endDate = new Date(dateStr.slice(0, 4), dateStr.slice(4, 6) - 1, dateStr.slice(6, 8));
	const today = new Date();

	// 시차 제거
	endDate.setHours(0, 0, 0, 0);
	today.setHours(0, 0, 0, 0);

	const diffTime = endDate.getTime() - today.getTime();
	const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

	// 출력 포맷
	if (diffDays > 0) {
		return `D-${diffDays}`;
	} else if (diffDays === 0) {
		return "D-Day";
	} else {
		return `D+${Math.abs(diffDays)}`;
	}
}

// 모든 dday-text 요소에 대해 D-Day 계산 후 삽입
document.querySelectorAll('.policy-labels').forEach(label => {
	const date = label.getAttribute('data-end-date');
	const ddaySpan = label.querySelector('.dday-text');
	if (ddaySpan && date) {
		ddaySpan.textContent = getDday(date);
	}
});
