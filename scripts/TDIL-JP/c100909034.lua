--ブロックドラゴン
--Block Dragon
--Script by nekrozar
function c100909034.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c100909034.spcon)
	e2:SetOperation(c100909034.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c100909034.reptg)
	e3:SetValue(c100909034.repval)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100909034,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c100909034.thcon)
	e4:SetTarget(c100909034.thtg)
	e4:SetOperation(c100909034.thop)
	c:RegisterEffect(e4)
end
function c100909034.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToRemoveAsCost()
end
function c100909034.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100909034.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,c)
end
function c100909034.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100909034.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,3,3,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100909034.repfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_ROCK) and not c:IsReason(REASON_BATTLE)
end
function c100909034.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100909034.repfilter,1,nil,e,tp) end
	local g=eg:Filter(c100909034.repfilter,nil,e,tp)
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c100909034.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c100909034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100909034.thfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToHand()
end
function c100909034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100909034.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckWithSumEqual(Card.GetLevel,8,1,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100909034.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100909034.thfilter,tp,LOCATION_DECK,0,nil)
	if g:CheckWithSumEqual(Card.GetLevel,8,1,3) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,8,1,3)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
