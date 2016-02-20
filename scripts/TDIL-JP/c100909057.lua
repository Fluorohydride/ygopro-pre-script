--黒の魔導陣
--Dark Magic Circle
--Script by dest
--e1 needs updated files from https://github.com/Fluorohydride/ygopro-scripts/pull/273 in order to work
function c100909057.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100909057)
	e1:SetOperation(c100909057.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909057,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100909157)
	e2:SetCondition(c100909057.rmcon)
	e2:SetTarget(c100909057.rmtg)
	e2:SetOperation(c100909057.rmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
c100909058.dark_magician_list=true
function c100909057.filter(c)
	return ((c.dark_magician_list or c:IsCode(13604200) or c:IsCode(2314238) or c:IsCode(48680970) or c:IsCode(63391643) or c:IsCode(67227834) or c:IsCode(68334074) or c:IsCode(69542930) or c:IsCode(75190122) or c:IsCode(87210505) or c:IsCode(99789342)) or c:IsCode(46986414)) and c:IsAbleToHand()
end
function c100909057.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c100909057.filter,1,nil) and e:GetHandler():IsRelateToEffect(e)
		and Duel.SelectYesNo(tp,aux.Stringid(100909057,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c100909057.filter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,2)
	else Duel.SortDecktop(tp,tp,3) end
end
function c100909057.cfilter(c,tp)
	return c:IsCode(46986414) and c:IsControler(tp)
end
function c100909057.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100909057.cfilter,1,nil,tp)
end
function c100909057.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100909057.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
