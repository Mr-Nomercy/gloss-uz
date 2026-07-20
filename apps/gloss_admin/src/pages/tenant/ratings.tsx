import { Star } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { mockReviews } from "@/lib/data";

export default function TenantRatings() {
  const avgRating =
    mockReviews.reduce((s, r) => s + r.rating, 0) / mockReviews.length;

  return (
    <div className="space-y-6">
      <Card>
        <CardContent className="p-8 text-center">
          <div className="text-5xl font-bold text-gloss-green">
            {avgRating.toFixed(1)}
          </div>
          <div className="mt-2 flex justify-center gap-1">
            {[1, 2, 3, 4, 5].map((s) => (
              <Star
                key={s}
                className={`h-6 w-6 ${s <= Math.round(avgRating) ? "fill-gloss-star text-gloss-star" : "text-gloss-border"}`}
              />
            ))}
          </div>
          <p className="mt-2 text-gloss-hint">
            O'rtacha reyting ({mockReviews.length} ta sharh)
          </p>
        </CardContent>
      </Card>

      <div className="space-y-4">
        {mockReviews.map((r) => (
          <Card key={r.id}>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-semibold">{r.client}</p>
                  <div className="mt-1 flex gap-0.5">
                    {[1, 2, 3, 4, 5].map((s) => (
                      <Star
                        key={s}
                        className={`h-4 w-4 ${s <= r.rating ? "fill-gloss-star text-gloss-star" : "text-gloss-border"}`}
                      />
                    ))}
                  </div>
                </div>
                <span className="text-sm text-gloss-hint">{r.date}</span>
              </div>
              <p className="mt-3 text-gloss-text">{r.comment}</p>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
