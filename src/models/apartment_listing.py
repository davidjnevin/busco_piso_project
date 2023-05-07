from sqlalchemy import Boolean, Float, Integer, String
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

from src.db.connection import engine


class Base(DeclarativeBase):
    pass


class ApartmentListing(Base):
    __tablename__ = "apartment_listings"

    id: Mapped[int] = mapped_column(primary_key=True)
    site_id: Mapped[int] = mapped_column(Integer)
    title: Mapped[str] = mapped_column(String(50))
    description: Mapped[str] = mapped_column(String)
    address: Mapped[str] = mapped_column(String)
    price: Mapped[float] = mapped_column(Float)
    bedrooms: Mapped[int] = mapped_column(Integer)
    bathrooms: Mapped[int] = mapped_column(Integer)
    square_footage: Mapped[float] = mapped_column(Float)
    image: Mapped[str] = mapped_column(String)
    source: Mapped[str] = mapped_column(String)
    elevator: Mapped[Boolean] = mapped_column(Boolean)
    exterior: Mapped[Boolean] = mapped_column(Boolean)
    a_c: Mapped[Boolean] = mapped_column(Boolean)

    def __repr__(self) -> str:
        return f"ApartmentListing(id={self.id!r}, site_id={self.site_id!r}, title={self.title!r}, description={self.description!r}, address={self.address!r}, price={self.price!r}, bedrooms={self.bedrooms!r}, bathrooms={self.bathrooms!r}, square_footage={self.square_footage!r}, image={self.image!r}, source={self.source!r}, elevator={self.elevator!r}, exterior={self.exterior!r}, a_c={self.a_c!r})"  # noqa : E501


def create_apartment_listing():
    ApartmentListing.metadata.create_all(engine, checkfirst=True)
