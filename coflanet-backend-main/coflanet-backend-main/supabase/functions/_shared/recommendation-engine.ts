export interface TasteProfile {
  acidity: number;
  body: number;
  sweetness: number;
  bitterness: number;
}

export interface FlavorPref {
  fruity: boolean;
  floral: boolean;
  nutty_cocoa: boolean;
  roasted: boolean;
}

export type CoffeeType = "acidity" | "strong" | "sweet" | "balance";

export interface BeanForMatching {
  id: string;
  name: string;
  acidity: number | null;
  body: number | null;
  sweetness: number | null;
  bitterness: number | null;
}

export interface BeanTagForMatching {
  bean_id: string;
  category: string;
  descriptor: string | null;
}

export interface RankedBean {
  bean_id: string;
  bean_name: string;
  match_score: number;
  categories: string[];
}

const TASTE_DIMS: (keyof TasteProfile)[] = [
  "acidity",
  "body",
  "sweetness",
  "bitterness",
];

const TASTE_MIN = 0;
const TASTE_MAX = 100;
const W_TASTE = 0.6;
const W_FLAVOR = 0.4;

const FLAVOR_CAT: Record<keyof FlavorPref, string> = {
  fruity: "Fruity",
  floral: "Floral",
  nutty_cocoa: "Nutty/Cocoa",
  roasted: "Roasted",
};

const DESCRIPTOR_WEIGHTS: Record<string, number> = {
  "Fruity": 1.05, "Berry": 1.25, "Blackberry": 1.25, "Raspberry": 1.25,
  "Blueberry": 1.25, "Strawberry": 1.25, "Cranberry": 1.25,
  "Black Currant": 1.25, "Dried fruit": 1.15, "Raisin": 1.15,
  "Prune": 1.15, "Fig": 1.15, "Other fruit": 1.05, "Coconut": 1.05,
  "Cherry": 1.25, "Pomegranate": 1.2, "Pineapple": 1.15, "Grape": 1.2,
  "Apple": 1.15, "Peach": 1.2, "Pear": 1.15, "Lychee": 1.2,
  "Mango": 1.2, "Guava": 1.15, "Citrus fruit": 1.25,
  "Grapefruit": 1.25, "Orange": 1.25, "Lemon": 1.25, "Lime": 1.25,
  "Sour/Fermented": 1, "Sour": 0.85, "Sour aromatics": 0.85,
  "Acetic acid": 0.85, "Butyric acid": 0.85, "Isovaleric acid": 0.85,
  "Citric acid": 0.85, "Malic acid": 0.85, "Alcohol/Fermented": 1,
  "Winey": 1.3, "Whiskey": 1, "Fermented": 1.05, "Overripe": 1.05,
  "Green/Vegetative": 1, "Olive oil": 0.85, "Raw": 0.85,
  "Under-ripe": 0.85, "Peapod": 0.85, "Fresh": 1, "Dark green": 1,
  "Vegetative": 1, "Hay-like": 0.85, "Herb-like": 1, "Lemongrass": 1.1,
  "Eucalyptus": 1, "Beany": 0.85,
  "Other": 0.7, "Papery/Musty": 0.7, "Stale": 0.7, "Cardboard": 0.7,
  "Papery": 0.7, "Woody": 0.7, "Moldy/Damp": 0.7, "Musty/Dusty": 0.7,
  "Musty/Earthy": 0.7, "Animalic": 0.7, "Meaty/Brothy": 0.7,
  "Phenolic": 0.7, "Chemical": 0.7, "Bitter": 0.7, "Salty": 0.7,
  "Medicinal": 0.7, "Petroleum": 0.5, "Skunky": 0.5, "Rubber": 0.5,
  "Roasted": 1.15, "Pipe tobacco": 1.05, "Tobacco": 1.15, "Burnt": 0.85,
  "Acrid": 0.85, "Ashy": 0.85, "Smoky": 0.85, "Brown, Roast": 0.85,
  "Cereal": 1, "Grain": 1, "Malt": 1,
  "Spices": 1.05, "Pungent": 1.05, "Pepper": 1.05, "Brown spice": 1.15,
  "Anise": 1.15, "Nutmeg": 1.15, "Cinnamon": 1.15, "Clove": 1.15,
  "Nutty/Cocoa": 1.15, "Nutty": 1.25, "Peanuts": 1.25, "Hazelnut": 1.25,
  "Almond": 1.25, "Walnut": 1.25, "Pistachio": 1.25, "Cashew": 1.25,
  "Macadamia": 1.25, "Cocoa": 1.25, "Chocolate": 1.25,
  "Dark chocolate": 1.25, "Milk Chocolate": 1.25,
  "Sweet": 1.05, "Brown sugar": 1.25, "Molasses": 1.25,
  "Mapple syrup": 1.25, "Caramelized": 1.25, "Honey": 1.25,
  "Vanilla": 1.15, "Vanillin": 1, "Overall sweet": 1,
  "Sweet Aromatics": 1.15,
  "Floral": 1.15, "Black Tea": 1.15, "Earl Grey": 1.15,
  "Chamomile": 1.15, "Rose": 1.3, "Jasmine": 1.3, "Lavender": 1.25,
  "Cherry Blossom": 1.25, "White Flower": 1.2,
};

function euclideanSimilarity(a: number[], b: number[]): number {
  let sum = 0;
  for (let i = 0; i < a.length; i++) {
    const d = a[i] - b[i];
    sum += d * d;
  }
  const dist = Math.sqrt(sum);
  const maxDist = Math.sqrt(a.length * (TASTE_MAX - TASTE_MIN) ** 2);
  return 1 - dist / maxDist;
}

function tasteSimilarity(user: TasteProfile, coffee: TasteProfile): number {
  const uv = TASTE_DIMS.map((dim) => user[dim] ?? 50);
  const cv = TASTE_DIMS.map((dim) => coffee[dim] ?? 50);
  return euclideanSimilarity(uv, cv);
}

function flavorMatchRatio(pref: FlavorPref, coffeeCategories: string[]): number {
  const preferred = (Object.keys(pref) as (keyof FlavorPref)[])
    .filter((k) => pref[k])
    .map((k) => FLAVOR_CAT[k]);

  if (preferred.length === 0) return 0;
  const matched = preferred.filter((cat) => coffeeCategories.includes(cat)).length;
  return matched / preferred.length;
}

function qualityScore(descriptors: string[]): number {
  if (!descriptors || descriptors.length === 0) return 1.0;
  const total = descriptors.reduce((sum, descriptor) => sum + (DESCRIPTOR_WEIGHTS[descriptor] ?? 1.0), 0);
  return total / descriptors.length;
}

function totalScore(taste: number, flavor: number, quality: number): number {
  const base = W_TASTE * taste + W_FLAVOR * flavor;
  const multiplier = 0.9 + (quality - 0.5) * (0.2 / 0.8);
  return Math.min(1.0, base * multiplier);
}

function toAlgoCategory(category: string): string {
  return category === "Nutty_Cocoa" ? "Nutty/Cocoa" : category;
}

export function rankBeans(
  beans: BeanForMatching[],
  tags: BeanTagForMatching[],
  userTaste: TasteProfile,
  flavorPref: FlavorPref,
): RankedBean[] {
  const beanCategories: Record<string, string[]> = {};
  const beanDescriptors: Record<string, string[]> = {};

  for (const tag of tags) {
    const beanId = tag.bean_id;
    if (!beanCategories[beanId]) beanCategories[beanId] = [];
    if (!beanDescriptors[beanId]) beanDescriptors[beanId] = [];

    const normalizedCategory = toAlgoCategory(tag.category);
    if (!beanCategories[beanId].includes(normalizedCategory)) {
      beanCategories[beanId].push(normalizedCategory);
    }
    if (tag.descriptor) beanDescriptors[beanId].push(tag.descriptor);
  }

  const ranked = beans.map((bean) => {
    const categories = beanCategories[bean.id] ?? [];
    const descriptors = beanDescriptors[bean.id] ?? [];

    const coffeeTaste: TasteProfile = {
      acidity: bean.acidity ?? 50,
      body: bean.body ?? 50,
      sweetness: bean.sweetness ?? 50,
      bitterness: bean.bitterness ?? 50,
    };

    const score = totalScore(
      tasteSimilarity(userTaste, coffeeTaste),
      flavorMatchRatio(flavorPref, categories),
      qualityScore(descriptors),
    );

    return {
      bean_id: bean.id,
      bean_name: bean.name,
      match_score: Math.round(score * 10000) / 10000,
      categories,
    } satisfies RankedBean;
  });

  ranked.sort((a, b) => b.match_score - a.match_score);
  return ranked;
}
