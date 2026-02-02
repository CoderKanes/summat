/**
 * 비밀번호 확인 게이트 공통 JS
 * - a / button / form 전부 가로채기
 * - HTML에는 의도만 표시 (data-password-check)
 * 사용예:
 * <form action="AAA.jsp" method="post" data-password-check > </form>
 * <a href="/summat/sm/BBB.jsp" data-password-check> BBB로 </a>
 * <button data-password-check data-next="CCC.jsp"> CCC버튼 </button>
 * <input type="button" data-password-check data-next="DDD.jsp" value="DDD버튼" />
 */

const CHECK_PASSWORD_URL = "/summat/util/checkPassword.jsp";

function submitToPasswordGate(next, params = []) {
    const form = document.createElement("form");
    form.method = "post"; 
    form.action = CHECK_PASSWORD_URL;

    // next
    const nextInput = document.createElement("input");
    nextInput.type = "hidden";
    nextInput.name = "next";
    nextInput.value = next;
    form.appendChild(nextInput);

    // params
    params.forEach(({ name, value }) => {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = name;
        input.value = value;
        form.appendChild(input);
    });
	
    document.body.appendChild(form);
    form.submit();
	
	/*
	const query = new URLSearchParams();

    // next
    query.append("next", next);

    // params
    params.forEach(({ name, value }) => {
        query.append(name, value);
    });
	const url = `${CHECK_PASSWORD_URL}?${query.toString()}`;
	
	alert(url);
	window.location.replace(url);*/
}

document.addEventListener("DOMContentLoaded", () => {

    /** -----------------------------
     *  a 태그 가로채기
     * ----------------------------- */
    document.querySelectorAll("a[data-password-check]").forEach(a => {
        a.addEventListener("click", e => {
            e.preventDefault();

            const next = a.href;
            submitToPasswordGate(next);
        });
    });

    /** -----------------------------
     *  button 가로채기
     * ----------------------------- */
    document.querySelectorAll("button[data-password-check]").forEach(btn => {
        btn.addEventListener("click", e => {
            e.preventDefault();

            const next = new URL(btn.dataset.next, location.href).href;
            if (!next) {
                console.warn("data-next가 없습니다.");
                return;
            }

            submitToPasswordGate(next);
        });
    });
	
	document.querySelectorAll('input[type="button"][data-password-check]').forEach(btn => {
	        btn.addEventListener("click", e => {
	            e.preventDefault();

	            const next =  new URL(btn.dataset.next, location.href).href;
	            if (!next) {
	                console.warn("data-next가 없습니다.");
	                return;
	            }

	            submitToPasswordGate(next);
	        });
	    });

    /** -----------------------------
     *  form submit 가로채기
     * ----------------------------- */
    document.querySelectorAll("form[data-password-check]").forEach(f => {
        f.addEventListener("submit", e => {
            e.preventDefault();

            const next = f.action;
            const params = [];

            for (const el of f.elements) {
                if (!el.name) continue;

                params.push({
                    name: el.name,
                    value: el.value
                });
            }

            submitToPasswordGate(next, params);
        });
    });

});
