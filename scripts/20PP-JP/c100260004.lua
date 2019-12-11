--オルターガイスト・プークエリ

--Scripted by nekrozar
function c100260004.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100260004)
	e1:SetValue(c100260004.matval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100260004,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100260104+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c100260004.thcon)
	e2:SetTarget(c100260004.thtg)
	e2:SetOperation(c100260004.thop)
	c:RegisterEffect(e2)
end
function c100260004.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x103)
end
function c100260004.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(100260004)
end
function c100260004.matval(e,c,mg)
	return c:IsSetCard(0x103) and mg:IsExists(c100260004.mfilter,1,nil) and not mg:IsExists(c100260004.exmfilter,1,nil)
end
function c100260004.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x103) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c100260004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100260004.cfilter,1,nil,tp)
end
function c100260004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100260004.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
