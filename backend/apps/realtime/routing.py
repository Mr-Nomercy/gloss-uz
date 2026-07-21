from django.urls import re_path

from .consumers import OrderConsumer, TeamConsumer

websocket_urlpatterns = [
    re_path(r"^ws/orders/(?P<order_id>\d+)/$", OrderConsumer.as_asgi()),
    re_path(r"^ws/teams/(?P<team_id>\d+)/$", TeamConsumer.as_asgi()),
]
