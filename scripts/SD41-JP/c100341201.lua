--Cyberdark End Dragon
--coded by Lyris
function c100341201.initial_effect(c)
	c:EnableReviveLimit()
	--mat="Cyberdark Dragon" + "Cyber End Dragon"
	aux.AddFusionProcCode2(c,40418351,1546123,true,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.fuslimit)
	c:RegisterEffect(e4)
	--Must be either Fusion Summoned, or Special Summoned by Tributing 1 Level 10 or lower "Cyberdark" Fusion Monster equipped with "Cyber End Dragon".
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c100341201.sprcon)
	e0:SetOperation(c100341201.sprop)
	c:RegisterEffect(e0)
	--Unaffected by your opponent's activated effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c100341201.efilter)
	c:RegisterEffect(e3)
	--Once per turn: You can equip 1 monster from either GY to this card.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetTarget(c100341201.eqtg)
	e2:SetOperation(c100341201.eqop)
	c:RegisterEffect(e2)
	--This card can attack a number of times each Battle Phase, up to the number of Equip Cards equipped to it.
	local e1=e3:Clone()
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c100341201.val)
	c:RegisterEffect(e1)
end
function c100341201.rfilter(c,tc)
	local tp=tc:GetControler()
	return c:IsConteroler(tp) and c:IsLevelBelow(10) and c:IsSetCard(0x4093) and c:IsFusionType(TYPE_FUSION) and c:GetEquipGroup():IsExists(aux.AND(Card.IsCode,1,nil,1546123) and Duel.GetLocationCountFromEx(tp,tp,c,tc) and c:IsCanBeFusionMaterial(tc,SUMMON_TYPE_SPECIAL)
end
function c100341201.sprcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c100341201.rfilter,1,nil,c)
end
function c100341201.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c100341201.rfilter,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c100341201.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end
function c100341201.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c100341201.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100341201.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,PLAYER_ALL,0)
end
function c100341201.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100341201.eqfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c100341201.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c100341201.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100341201.val(e,c)
	return c:GetEquipCount()-1
end
