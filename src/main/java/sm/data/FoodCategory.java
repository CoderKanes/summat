package sm.data;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FoodCategory {
	private String name;
    private List<String> cultureCategories;
    private List<String> foodTypeCategories;
	FoodCategory(String name, String cultures, String foodTypes)
	{
		this.name = name;

		// 1. 국가 카테고리 변환
		if (cultures != null && !cultures.isEmpty()) {
			// Arrays.asList는 고정 크기 리스트를 반환하므로,
			// 나중에 추가/삭제가 가능하도록 new ArrayList<>로 감싸는 것이 좋습니다.
			this.cultureCategories = new ArrayList<>(Arrays.asList(cultures.split(",")));
		} else {
			this.cultureCategories = new ArrayList<>();
		}

		// 2. 음식 타입 카테고리 변환
		if (foodTypes != null && !foodTypes.isEmpty()) {
			this.foodTypeCategories = new ArrayList<>(Arrays.asList(foodTypes.split(",")));
		} else {
			this.foodTypeCategories = new ArrayList<>();
		}
	}
    public String getName() { return name; }
    public List<String> getCultureCategories() { return cultureCategories; }
    public List<String> getFoodTypeCategories() { return foodTypeCategories; }
}
