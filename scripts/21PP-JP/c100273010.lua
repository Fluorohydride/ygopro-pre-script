--インフェルニティ・セイジ
--Infernity Sage
--Script by TheOnePharaoh
function c100273010.initial_effect(c)
	--Discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273010,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100273010)
	e1:SetTarget(c100273010.hdtg)
	e1:SetOperation(c100273010.hdop)
	c:RegisterEffect(e1)
	--To GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100273010,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100273110)
	e2:SetTarget(c100273010.tgtg)
	e2:SetOperation(c100273010.tgop)
	c:RegisterEffect(e2)
end
function c100273010.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,g:GetCount())
end
function c100273010.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function c100273010.tgfilter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c100273010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
		and Duel.IsExistingMatchingCard(c100273010.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100273010.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100273010.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
