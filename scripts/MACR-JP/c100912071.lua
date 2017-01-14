--十二獣の相剋
--Zoodiac Xiangke
--Scripted by Eerie Code
function c100912071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912071,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100912071)
	e2:SetCondition(c100912071.rcon)
	e2:SetOperation(c100912071.rop)
	c:RegisterEffect(e2)
	--attach
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c100912071.xyzcost)
	e3:SetTarget(c100912071.xyztg)
	e3:SetOperation(c100912071.xyzop)
	c:RegisterEffect(e3)
end
function c100912071.rfilter(c,oc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,oc,REASON_COST)
end
function c100912071.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
		and re:IsActiveType(TYPE_XYZ) and ep==e:GetOwnerPlayer() and rc:IsSetCard(0xf1)
		and Duel.IsExistingMatchingCard(c100912071.rfilter,tp,LOCATION_MZONE,0,1,rc,ev)
end
function c100912071.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	local rc=re:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c100912071.rfilter,tp,LOCATION_MZONE,0,1,1,rc,ct)
	tc:RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c100912071.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100912071.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xf1)
end
function c100912071.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100912071.xyzfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100912071,1))
	local g1=Duel.SelectTarget(tp,c100912071.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100912071,2))
	local g2=Duel.SelectTarget(tp,c100912071.xyzfilter,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
end
function c100912071.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	local xc=g:GetNext()
	if xc==e:GetLabelObject() then tc,xc=xc,tc end
	Duel.Overlay(tc,Group.FromCards(xc))
end
