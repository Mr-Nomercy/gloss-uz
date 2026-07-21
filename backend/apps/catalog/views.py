from rest_framework import viewsets

from .models import Addon, ServiceCategory, Tariff, TimeSlot
from .serializers import (
    AddonSerializer,
    ServiceCategorySerializer,
    TariffSerializer,
    TimeSlotSerializer,
)


class ServiceCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ServiceCategory.objects.prefetch_related("tariffs__addons").order_by("id")
    serializer_class = ServiceCategorySerializer


class TariffViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = (
        Tariff.objects.select_related("service_category").prefetch_related("addons").order_by("id")
    )
    serializer_class = TariffSerializer


class AddonViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Addon.objects.select_related("tariff").order_by("id")
    serializer_class = AddonSerializer


class TimeSlotViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = TimeSlot.objects.order_by("date", "start_time")
    serializer_class = TimeSlotSerializer
