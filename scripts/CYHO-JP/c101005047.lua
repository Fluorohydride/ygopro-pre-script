--閃刀姫-ハヤテ
--Brandish Maiden Hayate
--Scripted by ahtelel
function c101005047.initial_effect(c)
	c:SetSPSummonOnce(101005047)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101005047.matfilter,1,1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101005047,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c101005047.gytg)
	e2:SetOperation(c101005047.gyop)
	c:RegisterEffect(e2)
end
function c101005047.matfilter(c,scard,sumtype,tp)
	return c:IsLinkSetCard(0x1115) and not c:IsAttribute(ATTRIBUTE_WIND,scard,sumtype,tp)
end
function c101005047.tgfilter(c)
	return c:IsSetCard(0x115) and c:IsAbleToGrave()
end
function c101005047.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005047.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101005047.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101005047.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
