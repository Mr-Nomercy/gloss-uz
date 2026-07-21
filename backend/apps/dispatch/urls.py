from django.urls import path

from .views import AcceptOfferView

urlpatterns = [
    path("orders/<int:order_id>/accept/", AcceptOfferView.as_view(), name="dispatch-accept"),
]
