from rest_framework.routers import DefaultRouter

from .views import AddonViewSet, ServiceCategoryViewSet, TariffViewSet, TimeSlotViewSet

router = DefaultRouter()
router.register("service-categories", ServiceCategoryViewSet, basename="service-category")
router.register("tariffs", TariffViewSet, basename="tariff")
router.register("addons", AddonViewSet, basename="addon")
router.register("time-slots", TimeSlotViewSet, basename="time-slot")

urlpatterns = router.urls
